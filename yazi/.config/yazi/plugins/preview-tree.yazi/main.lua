local M = {}

local function fail(s, ...)
  ya.notify { title = "Preview tree", content = string.format(s, ...), timeout = 5, level = "error" }
end

local function is_in_tmux()
  if os.getenv "TMUX" then
    return true
  end
  return false
end

local function is_in_wezterm()
  if os.getenv "TERMINAL" == "wezterm" then
    return true
  end
  return false
end

-- Function to get file extension
local get_file_extension = function(filename)
  local pattern_mp3 = "%.mp3$"
  local pattern_wav = "%.wav$"
  local pattern_mp4 = "%.mp4$"
  local pattern_gif = "%.gif$"
  local pattern_pdf = "%.pdf$"
  local pattern_png = "%.png$"
  local pattern_jpg = "%.jpg$"
  local pattern_jpeg = "%.jpeg$"
  local pattern_webp = "%.webp$"
  local pattern_mkv = "%.mkv$"
  local pattern_avi = "%.avi$"

  if string.match(filename, pattern_mp3) then
    return "mp3"
  elseif string.match(filename, pattern_wav) then
    return "mp3"
  elseif string.match(filename, pattern_mp4) then
    return "mp4"
  elseif string.match(filename, pattern_mkv) then
    return "mp4"
  elseif string.match(filename, pattern_avi) then
    return "mp4"
  elseif string.match(filename, pattern_gif) then
    return "mp4"
  elseif string.match(filename, pattern_pdf) then
    return "pdf"
  elseif string.match(filename, pattern_jpg) then
    return "jpg"
  elseif string.match(filename, pattern_png) then
    return "jpg"
  elseif string.match(filename, pattern_webp) then
    return "jpg"
  elseif string.match(filename, pattern_jpeg) then
    return "jpg"
  else
    return "none"
  end
end

-- Function to get the hovered item path
local get_hovered_item_path = ya.sync(function(_)
  local hovered_item = cx.active.current.hovered
  if hovered_item then
    return tostring(cx.active.current.hovered.url)
  else
    return nil
  end
end)

local exec_os_cmd = function(pane_id, cmds)
  local term_cmd
  if is_in_tmux() then
    term_cmd = "tmux send-keys -t " .. pane_id .. " "
    term_cmd = term_cmd .. " '" .. cmds .. "' C-m "
  elseif is_in_wezterm() then
    term_cmd = "wezterm cli send-text --no-paste "
    term_cmd = term_cmd .. '"' .. cmds .. '"\r ' .. " --pane-id " .. pane_id
  end

  os.execute(term_cmd)
end

-- Escape single qote
local function shell_escape_single_quote(s)
  return s:gsub("'", "'\\''")
end

local function shell_kill_process_by_name(process_name)
  if not process_name then
    error "program_name required"
  end

  -- try sending SIGTERM first, wait a bit, then use SIGKILL if it’s still running.
  -- use pkill if it’s available. Redirect the output to /dev/null.
  local kill_cmd = [[
        pkill -15 -x ]] .. process_name .. [[ >/dev/null 2>&1 || true
        sleep 0.15
        pkill -9 -x ]] .. process_name .. [[ >/dev/null 2>&1 || true
    ]]

  os.execute(kill_cmd)
end

local function play_with_mpv_nohup(fpath, only_sound)
  if not fpath then
    error "fpath required"
  end

  local fpath_esc = shell_escape_single_quote(fpath)

  shell_kill_process_by_name "mpv"

  local play_cmd

  if not only_sound then
    -- for mp4, gif
    play_cmd = "nohup mpv --really-quiet --autofit=1000x900 '" .. fpath_esc .. "' >/dev/null 2>&1 &"
  else
    -- for mp3
    play_cmd = "nohup mpv --really-quiet '" .. fpath_esc .. "' >/dev/null 2>&1 &"
  end

  os.execute(play_cmd)
end

local gen_cmd_ext = function(pane_id, fpath_ext, fpath)
  if fpath_ext == "mp3" then
    play_with_mpv_nohup(fpath, true)
  end

  if fpath_ext == "pdf" then
    shell_kill_process_by_name "zathura"
    os.execute("nohup zathura '" .. fpath .. "' >/dev/null 2>&1 &")
  end

  if fpath_ext == "mp4" then
    play_with_mpv_nohup(fpath)
  end

  if fpath_ext == "jpg" then
    if not pane_id or (pane_id == 0) then
      error "must define `pane_id`"
      return
    end

    if os.getenv "TERMINAL" == "st" then
      os.execute('sxiv "' .. fpath .. '" >/dev/null 2>&1 &')
    else
      exec_os_cmd(pane_id, "clear")
      exec_os_cmd(
        pane_id,
        [[kitty +kitten icat --silent --scale-up --transfer-mode=memory --align left --stdin=no ]] .. fpath
      )
    end
  end
end

local function get_output_string_cmd(cmd, args)
  local child, _ = Command(cmd):arg(args):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):output()

  if not child then
    return fail "OPEN_WITH_WEZTERM: Get pane_id went wrong"
  end

  return child.stdout:gsub("\n$", "")
end

local function send_text_cmds(cmd, args)
  if type(args) ~= "table" then
    fail "`args` must be a table"
    return
  end

  local child, err_cmd =
    Command(cmd):arg(args):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

  if not child then
    return fail("Spawn `cmd` failed with error code", err_cmd)
  end

  local output, err = child:wait_with_output()
  if not output then
    return fail("No output! Command: %s, Args: %s, Error: %s", cmd, table.concat(args, " "), err)
  elseif not output.status.success and output.status.code ~= 130 then
    return fail(
      "Command failed! Command: `%s`, Args: `%s`, Exit status code: %s",
      cmd,
      table.concat(args, " "),
      output.status.code
    )
  end
end

local function open_with_tmux(fpath_ext, fpath)
  if fpath_ext == "jpg" and os.getenv "TERMINAL" == "st" then
    gen_cmd_ext(3, fpath_ext, fpath)
    return
  end

  if fpath_ext ~= "jpg" then
    gen_cmd_ext(nil, fpath_ext, fpath)
    return
  end

  local list_panes = get_output_string_cmd("sh", { "-c", "tmux list-panes | wc -l" })

  if tonumber(list_panes) < 3 or (tonumber(list_panes) == 2) then
    send_text_cmds("tmux", { "split-window", "-vl", "40", "-c", "#{pane_current_path}" })
    send_text_cmds("tmux", { "split-window", "-fv", ";", "swapp", "-t", "!", ";", "killp", "-t", "!" })
    send_text_cmds("tmux", { "resize-pane", "-U", "2" })
    send_text_cmds("tmux", { "last-pane" })
  end

  gen_cmd_ext(3, fpath_ext, fpath)
end

local function open_with_wezterm(fpath_ext, fpath)
  local pane_id = get_output_string_cmd("wezterm", { "cli", "get-pane-direction", "down" })

  if #pane_id == 0 and (fpath_ext == "jpg") then
    pane_id = get_output_string_cmd("wezterm", { "cli", "split-pane", "--bottom" })
    fail(pane_id)
  end

  gen_cmd_ext(pane_id, fpath_ext, fpath)
  send_text_cmds("tmux", { "last-pane" })
end

-- function M:setup()
-- 	toggle_view_mode()
-- end

function M:entry(_)
  local fpath = get_hovered_item_path()
  if fpath == nil then
    fail "This file is unknown format?"
    return
  end

  local fpath_ext = get_file_extension(tostring(fpath))

  if is_in_tmux() then
    open_with_tmux(fpath_ext, fpath)
  elseif is_in_wezterm() then
    open_with_wezterm(fpath_ext, fpath)
  end
end

return M
