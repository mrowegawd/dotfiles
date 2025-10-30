local M = {}

---@alias FileExt "mp3" |"mp4" | "pdf"| "jpg" | nil

---@class CliArgs
---@field cmd string
---@field args string[]

local function fail(s, ...)
  ---@diagnostic disable-next-line: undefined-global
  ya.notify { title = "Preview tree", content = string.format(s, ...), timeout = 5, level = "error" }
end

---@param filename string
---@return boolean
local function is_file_exists(filename)
  local file = io.open(filename, "r")
  if file then
    file:close()
    return true -- File ada
  end

  return false -- File tidak ada
end

---@return boolean
local function is_in_tmux()
  if os.getenv "TMUX" then
    return true
  end
  return false
end

---@return boolean
local function is_in_wezterm()
  if os.getenv "TERMINAL" == "wezterm" then
    return true
  end
  return false
end

---@param filename string
---@return FileExt
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
    return
  end
end

-- Function to get the hovered item path
---@diagnostic disable-next-line: undefined-global
local get_hovered_item_path = ya.sync(function(_)
  ---@diagnostic disable-next-line: undefined-global
  local hovered_item = cx.active.current.hovered
  if hovered_item then
    ---@diagnostic disable-next-line: undefined-global
    return tostring(cx.active.current.hovered.url)
  else
    return nil
  end
end)

---@param cmd string
---@param args table
local function send_text_cmds(cmd, args)
  if type(args) ~= "table" then
    fail "`args` must be a table"
    return
  end

  local child, err_cmd =
    ---@diagnostic disable-next-line: undefined-global
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

---@param pane_id number
---@param cmds string
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
---@return string
local function shell_escape_single_quote(s)
  return s:gsub("'", "'\\''")
end

---@param process_name string
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

---@param fpath string
---@param is_only_sound? boolean
local function play_with_mpv_nohup(fpath, is_only_sound)
  is_only_sound = is_only_sound or false

  if not fpath then
    error "fpath required"
  end

  local fpath_esc = shell_escape_single_quote(fpath)

  shell_kill_process_by_name "mpv"

  local play_cmd

  if not is_only_sound then
    -- for mp4, gif
    play_cmd = "nohup mpv --really-quiet --autofit=1000x900 '" .. fpath_esc .. "' >/dev/null 2>&1 &"
  else
    -- for mp3
    play_cmd = "nohup mpv --really-quiet '" .. fpath_esc .. "' >/dev/null 2>&1 &"
  end

  os.execute(play_cmd)
end

---@param pane_id number
---@param fpath_ext FileExt
---@param fpath string
---@param back_to_pane_id? number
local gen_cmd_ext = function(pane_id, fpath_ext, fpath, back_to_pane_id)
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

      if is_in_wezterm() and back_to_pane_id then
        send_text_cmds("wezterm", { "cli", "activate-pane", "--pane-id", back_to_pane_id })
      end
    end
  end
end

---@param cmd string
---@param args table
---@return string | nil
local function get_output_string_cmd(cmd, args)
  ---@diagnostic disable-next-line: undefined-global
  local child, _ = Command(cmd):arg(args):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):output()

  if not child then
    fail "OPEN_WITH_WEZTERM: Get pane_id went wrong"
    return
  end

  return child.stdout:gsub("\n$", "")
end

---@param fpath_ext string
---@param fpath string
local function open_with_tmux(fpath_ext, fpath)
  if fpath_ext == "jpg" and os.getenv "TERMINAL" == "st" then
    gen_cmd_ext(3, fpath_ext, fpath)
    return
  end

  if fpath_ext ~= "jpg" then
    gen_cmd_ext(_, fpath_ext, fpath)
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

---@param pane_id string
---@param cmds? CliArgs
---@param direction "Down"| "Left" | "Up" | "Right" | "None"
---@return string | nil | "none"
local function get_extract_output_string_cmd_wezterm(pane_id, direction, cmds)
  local get_pane_id
  if cmds then
    get_pane_id = get_output_string_cmd(cmds.cmd, cmds.args)
  else
    get_pane_id = get_output_string_cmd("wezterm", { "cli", "get-pane-direction", "--pane-id", pane_id, direction })
  end

  if get_pane_id == nil then
    if cmds then
      fail(
        "Get pane `"
          .. cmds.cmd
          .. "` failed, with args `"
          .. table.concat(cmds.args, " ")
          .. " with output: "
          .. tostring(get_pane_id)
          .. "`.\nCheck your `args` commands"
      )
    else
      fail("Get pane `" .. pane_id .. "` failed, with direction `" .. direction .. "`.\nCheck your `args` commands")
    end
    return
  end

  if get_pane_id == "" then
    return ""
  end

  return get_pane_id
end

---@param fpath_ext FileExt
---@param fpath string
local function open_with_wezterm(fpath_ext, fpath)
  local current_pane_id = os.getenv "WEZTERM_PANE"
  local pane_id_target

  if fpath_ext ~= "jpg" then
    gen_cmd_ext(0, fpath_ext, fpath)
    return
  end

  local path_pane_id_preview_wezterm = "/tmp/wezterm-pane-id-preview"
  if is_file_exists(path_pane_id_preview_wezterm) then
    local cat_output_file = get_extract_output_string_cmd_wezterm("", "Up", {
      cmd = "cat",
      args = { path_pane_id_preview_wezterm },
    })
    if not cat_output_file then
      return
    end

    pane_id_target = cat_output_file

    local calm = get_extract_output_string_cmd_wezterm("", "Up", {
      cmd = "sh",
      args = { "-c", "wezterm cli list | grep " .. pane_id_target },
    })

    if calm ~= "" then
      local pane_id = tonumber(pane_id_target)
      local back_to_pane_id = tonumber(current_pane_id)
      if pane_id then
        gen_cmd_ext(pane_id, fpath_ext, fpath, back_to_pane_id)
      end
      return
    end
  end

  local raw_list_panes = get_output_string_cmd("sh", { "-c", "wezterm cli list | wc -l" })
  if not raw_list_panes then
    return
  end
  local total_panes = tonumber(raw_list_panes) > 0 and tonumber(raw_list_panes) - 1 or tonumber(raw_list_panes)

  if tonumber(total_panes) > 1 or (tonumber(total_panes) == 2) then
    local pane_id_nvim = get_extract_output_string_cmd_wezterm("", "Up", {
      cmd = "wezterm",
      args = { "cli", "get-pane-direction", "Left" },
    })
    if not pane_id_nvim then
      return
    end

    local check_id_below_nvim = get_extract_output_string_cmd_wezterm("", "Up", {
      cmd = "wezterm",
      args = { "cli", "get-pane-direction", "--pane-id", pane_id_nvim, "Down" },
    })
    if not check_id_below_nvim then
      return
    end

    if check_id_below_nvim == "" then
      if is_file_exists(path_pane_id_preview_wezterm) then
        os.execute("rm " .. path_pane_id_preview_wezterm)
      end

      local create_split_window = get_extract_output_string_cmd_wezterm("", "Up", {
        cmd = "wezterm",
        args = { "cli", "split-pane", "--pane-id", pane_id_nvim, "--bottom" },
      })
      if not create_split_window then
        return
      end

      pane_id_target = create_split_window
    end

    if not is_file_exists(path_pane_id_preview_wezterm) then
      os.execute('echo "' .. pane_id_target .. '"  > ' .. path_pane_id_preview_wezterm)
    end
  end

  local pane_id = tonumber(pane_id_target)
  local back_to_pane_id = tonumber(current_pane_id)
  if pane_id then
    gen_cmd_ext(pane_id, fpath_ext, fpath, back_to_pane_id)
  end
end

function M:entry(_)
  local fpath = get_hovered_item_path()
  if fpath == nil then
    fail "This file is unknown format?"
    return
  end

  ---@type FileExt
  local fpath_ext = get_file_extension(tostring(fpath))
  if not fpath_ext then
    return
  end

  if is_in_tmux() then
    open_with_tmux(fpath_ext, fpath)
  elseif is_in_wezterm() then
    open_with_wezterm(fpath_ext, fpath)
  end
end

return M
