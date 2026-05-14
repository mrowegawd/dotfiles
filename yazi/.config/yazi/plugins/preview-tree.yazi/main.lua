local M = {}

---@alias FileExt "mp3" | "mp4" | "pdf" | "jpg" | nil

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ UTILS                                                    ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

---@param msg string
local function fail(msg)
  ---@diagnostic disable-next-line: undefined-global
  ya.notify { title = "Preview tree", content = msg, timeout = 5, level = "error" }
end

---@param filename string
---@return boolean
local function is_file_exists(filename)
  local f = io.open(filename, "r")
  if f then
    f:close()
    return true
  end
  return false
end

---@return boolean
local function is_in_tmux()
  return os.getenv "TMUX" ~= nil
end

---@return boolean
local function is_in_wezterm()
  return os.getenv "TERMINAL" == "wezterm"
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ FILE EXTENSION                                           ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

local EXT_MAP = {
  mp3 = "mp3",
  wav = "mp3",
  mp4 = "mp4",
  mkv = "mp4",
  avi = "mp4",
  gif = "mp4",
  pdf = "pdf",
  jpg = "jpg",
  png = "jpg",
  jpeg = "jpg",
  webp = "jpg",
}

---@param filename string
---@return FileExt
local function get_file_extension(filename)
  local ext = filename:match "%.([^%.]+)$"
  if ext then
    return EXT_MAP[ext:lower()]
  end
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ YAZI SYNC                                                ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

---@diagnostic disable-next-line: undefined-global
local get_hovered_item_path = ya.sync(function(_)
  ---@diagnostic disable-next-line: undefined-global
  local hovered = cx.active.current.hovered
  ---@diagnostic disable-next-line: undefined-global
  return hovered and tostring(cx.active.current.hovered.url) or nil
end)

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ COMMAND HELPERS                                          ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

---@param cmd string
---@param args table
---@return string | nil
local function get_cmd_output(cmd, args)
  ---@diagnostic disable-next-line: undefined-global
  local child, err = Command(cmd):arg(args):stdout(Command.PIPED):stderr(Command.INHERIT):output()
  if err then
    fail("Command failed: " .. tostring(err))
    return nil
  end
  local out = child.stdout or ""
  return out:gsub("[\r\n]+$", "")
end

---@param cmd string
---@param args table
local function send_cmd(cmd, args)
  if type(args) ~= "table" then
    fail "`args` must be a table"
    return
  end
  ---@diagnostic disable-next-line: undefined-global
  local child, err = Command(cmd):arg(args):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()
  if not child then
    fail("Spawn failed: " .. tostring(err))
    return
  end
  local output, out_err = child:wait_with_output()
  if not output then
    fail(string.format("No output: %s %s — %s", cmd, table.concat(args, " "), tostring(out_err)))
  elseif not output.status.success and output.status.code ~= 130 then
    fail(string.format("Command failed: `%s %s` (exit %s)", cmd, table.concat(args, " "), output.status.code))
  end
end

---@param pane_id string
---@param cmds string
local function exec_tmux_send_keys(pane_id, cmds)
  local term_cmd = "tmux send-keys -t " .. pane_id .. " '" .. cmds .. "' C-m"
  os.execute(term_cmd)
end

---@param pane_id string
---@param cmds string
local function exec_wezterm_send_keys(pane_id, cmds)
  local term_cmd = 'wezterm cli send-text --no-paste "' .. cmds .. '"\r --pane-id ' .. pane_id
  os.execute(term_cmd)
end

---@param pane_id string
---@param cmds string
local function exec_os_cmd(pane_id, cmds)
  if is_in_tmux() then
    exec_tmux_send_keys(pane_id, cmds)
  elseif is_in_wezterm() then
    exec_wezterm_send_keys(pane_id, cmds)
  end
end

---@return string
local function shell_escape_single_quote(s)
  return s:gsub("'", "'\\''")
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ PROCESS HELPERS                                          ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

---@param process_name string
local function kill_process_by_name(process_name)
  os.execute(
    "pkill -15 -x "
      .. process_name
      .. " >/dev/null 2>&1 || true\n"
      .. "sleep 0.15\n"
      .. "pkill -9 -x "
      .. process_name
      .. " >/dev/null 2>&1 || true"
  )
end

---@param fpath string
---@param is_only_sound? boolean
local function play_with_mpv(fpath, is_only_sound)
  local fpath_esc = shell_escape_single_quote(fpath)
  kill_process_by_name "mpv"

  if is_only_sound then
    os.execute("nohup mpv --really-quiet '" .. fpath_esc .. "' >/dev/null 2>&1 &")
  else
    os.execute("nohup mpv --really-quiet --autofit=600x600 --geometry=-15-60 '" .. fpath_esc .. "' >/dev/null 2>&1 &")
  end
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ PANE HELPERS (TMUX)                                      ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

---@param pane_id string
---@return boolean
local function is_pane_exists(pane_id)
  if not pane_id or pane_id == "" then
    return false
  end
  ---@diagnostic disable-next-line: undefined-global
  local child, err = Command("tmux")
    :arg({ "list-panes", "-a", "-F", "#{pane_id}" })
    ---@diagnostic disable-next-line: undefined-global
    :stdout(Command.PIPED)
    ---@diagnostic disable-next-line: undefined-global
    :stderr(Command.PIPED)
    :output()

  if err or not child or not child.stdout or child.stdout == "" then
    return false
  end

  for line in child.stdout:gmatch "[^\r\n]+" do
    if line == pane_id then
      return true
    end
  end
  return false
end

---@param session_id string
---@param window_id string
---@param field string
---@return string
local function get_json_field(session_id, window_id, field)
  local json_file = "/tmp/tmux-main-layout-workspaces.json"
  return get_cmd_output("jq", {
    "-r",
    "--arg",
    "s",
    session_id,
    "--arg",
    "w",
    window_id,
    "--arg",
    "f",
    field,
    ".[$s][$w][$f] // empty",
    json_file,
  }) or ""
end

---@param session_id string
---@param window_id string
---@param field string
---@param value string
local function update_json_field(session_id, window_id, field, value)
  local json_file = "/tmp/tmux-main-layout-workspaces.json"
  os.execute(
    string.format(
      "jq --arg s %q --arg w %q --arg f %q --arg v %q '.[$s][$w][$f] = $v' %s > /tmp/tmux-ws-tmp.json && mv /tmp/tmux-ws-tmp.json %s",
      session_id,
      window_id,
      field,
      value,
      json_file,
      json_file
    )
  )
end

local function wait_pane_ready(pane_id, max_retries)
  max_retries = max_retries or 10
  for _ = 1, max_retries do
    if is_pane_exists(pane_id) then
      return true
    end
    os.execute "sleep 0.1"
  end
  return false
end

---@param session_id string
---@param window_id string
---@return string | nil
local function create_toggle_term_pane(session_id, window_id)
  local main_pane_id = get_json_field(session_id, window_id, "main_pane_id")

  local split_target = (main_pane_id ~= "") and ("-t " .. main_pane_id) or ""
  local new_pane_id = get_cmd_output("sh", {
    "-c",
    "tmux split-window -vl 20 -c '#{pane_current_path}' " .. split_target .. " -P -F '#{pane_id}'",
  })

  if not new_pane_id or new_pane_id == "" then
    fail "Failed to create toggle term pane"
    return nil
  end

  -- Wait until the pane is ready
  if not wait_pane_ready(new_pane_id) then
    fail("Pane created but not responding: " .. new_pane_id)
    return nil
  end

  update_json_field(session_id, window_id, "toggle_term_pane_id", new_pane_id)
  return new_pane_id
end

---@return string | nil
local function resolve_toggle_term_pane_id()
  local session_id = get_cmd_output("sh", { "-c", "tmux display-message -p '#S'" })
  local window_id = get_cmd_output("sh", { "-c", "tmux display-message -p '#I'" })

  if not session_id or not window_id then
    fail "Cannot determine tmux session/window"
    return nil
  end

  local pane_id = get_json_field(session_id, window_id, "toggle_term_pane_id")

  if pane_id ~= "" and is_pane_exists(pane_id) then
    return pane_id
  end

  -- Pane tidak ada / stale → buat baru dan update JSON
  local new_pane_id = create_toggle_term_pane(session_id, window_id)
  if not new_pane_id then
    return nil
  end

  return new_pane_id
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ MEDIA OPEN                                               ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

---@param pane_id string
---@param fpath_ext FileExt
---@param fpath string
---@param back_to_pane_id? number
local function gen_cmd_ext(pane_id, fpath_ext, fpath, back_to_pane_id)
  if fpath_ext == "mp3" then
    play_with_mpv(fpath, true)
  elseif fpath_ext == "mp4" then
    play_with_mpv(fpath, false)
  elseif fpath_ext == "pdf" then
    kill_process_by_name "zathura"
    os.execute("nohup zathura '" .. fpath .. "' >/dev/null 2>&1 &")
  elseif fpath_ext == "jpg" then
    if not pane_id or pane_id == "" then
      fail "pane_id required for image preview"
      return
    end

    if os.getenv "TERMINAL" == "st" then
      kill_process_by_name "sxiv"
      os.execute('nohup sxiv "' .. fpath .. '" >/dev/null 2>&1 &')
    else
      exec_os_cmd(pane_id, "clear")
      exec_os_cmd(
        pane_id,
        "kitty +kitten icat --silent --scale-up --transfer-mode=memory --align left --stdin=no " .. fpath
      )

      if is_in_wezterm() and back_to_pane_id then
        send_cmd("wezterm", { "cli", "activate-pane", "--pane-id", tostring(back_to_pane_id) })
      end
    end
  end
end

local function center_pane_vertically(pane_id)
  os.execute([[
    pane_h=$(tmux display -p -t ]] .. pane_id .. [[ '#{pane_height}' 2>/dev/null)
    win_h=$(tmux display -p '#{window_height}' 2>/dev/null)
    if [ -n "$pane_h" ] && [ -n "$win_h" ]; then
      diff=$(( win_h / 2 - pane_h ))
      abs_diff=${diff#-}
      if [ "$abs_diff" -gt 2 ]; then
        if [ "$diff" -gt 0 ]; then
          tmux resize-pane -t ]] .. pane_id .. [[ -U $(( diff / 2 ))
        else
          tmux resize-pane -t ]] .. pane_id .. [[ -D $(( -diff / 2 ))
        fi
      fi
    fi
  ]])
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ OPEN WITH TMUX                                           ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

---@param fpath_ext FileExt
---@param fpath string
local function open_with_tmux(fpath_ext, fpath)
  -- Non-image: no need pane preview
  if fpath_ext ~= "jpg" then
    gen_cmd_ext("", fpath_ext, fpath)
    return
  end

  local preview_pane_id = resolve_toggle_term_pane_id()
  if not preview_pane_id then
    return
  end

  center_pane_vertically(preview_pane_id)
  gen_cmd_ext(preview_pane_id, fpath_ext, fpath)

  -- Back to yazi pane
  local yazi_pane_id = os.getenv "TMUX_PANE"
  if yazi_pane_id then
    os.execute("tmux select-pane -t " .. yazi_pane_id)
  end
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ OPEN WITH WEZTERM                                        ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

---@param pane_id string
---@param direction "Down" | "Left" | "Up" | "Right" | "None"
---@param cmds? { cmd: string, args: table }
---@return string | nil
local function wezterm_get_pane(pane_id, direction, cmds)
  local result
  if cmds then
    result = get_cmd_output(cmds.cmd, cmds.args)
  else
    result = get_cmd_output("wezterm", { "cli", "get-pane-direction", "--pane-id", pane_id, direction })
  end

  if result == nil then
    if cmds then
      fail("wezterm get pane failed: " .. cmds.cmd .. " " .. table.concat(cmds.args, " "))
    else
      fail("wezterm get pane direction `" .. direction .. "` failed for pane " .. pane_id)
    end
  end
  return result
end

---@param fpath_ext FileExt
---@param fpath string
local function open_with_wezterm(fpath_ext, fpath)
  local current_pane_id = os.getenv "WEZTERM_PANE"
  local pane_id_target

  if fpath_ext ~= "jpg" then
    gen_cmd_ext("0", fpath_ext, fpath)
    return
  end

  local path_preview_cache = "/tmp/wezterm-pane-id-preview"

  if is_file_exists(path_preview_cache) then
    local cached_id = wezterm_get_pane("", "Up", { cmd = "cat", args = { path_preview_cache } })
    if not cached_id then
      return
    end

    local is_alive = wezterm_get_pane("", "Up", {
      cmd = "sh",
      args = { "-c", "wezterm cli list | grep " .. cached_id },
    })

    if is_alive and is_alive ~= "" then
      local pane_id = tonumber(cached_id)
      if pane_id then
        gen_cmd_ext(tostring(pane_id), fpath_ext, fpath, tonumber(current_pane_id))
      end
      return
    end
  end

  -- Hitung total pane
  local raw = get_cmd_output("sh", { "-c", "wezterm cli list | wc -l" })
  if not raw then
    return
  end
  local total_panes = math.max(0, (tonumber(raw) or 1) - 1)

  if total_panes > 1 then
    local pane_id_nvim = wezterm_get_pane("", "Up", {
      cmd = "wezterm",
      args = { "cli", "get-pane-direction", "Left" },
    })
    if not pane_id_nvim then
      return
    end

    local pane_below_nvim = wezterm_get_pane("", "Up", {
      cmd = "wezterm",
      args = { "cli", "get-pane-direction", "--pane-id", pane_id_nvim, "Down" },
    })
    if not pane_below_nvim then
      return
    end

    if pane_below_nvim == "" then
      if is_file_exists(path_preview_cache) then
        os.execute("rm " .. path_preview_cache)
      end

      pane_id_target = wezterm_get_pane("", "Up", {
        cmd = "wezterm",
        args = { "cli", "split-pane", "--pane-id", pane_id_nvim, "--bottom" },
      })
      if not pane_id_target then
        return
      end
    end

    if not is_file_exists(path_preview_cache) then
      os.execute('echo "' .. pane_id_target .. '" > ' .. path_preview_cache)
    end
  end

  -- Back to yazi pane
  local pane_id = tonumber(pane_id_target)
  if pane_id then
    gen_cmd_ext(tostring(pane_id), fpath_ext, fpath, tonumber(current_pane_id))
  end
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ ENTRY                                                    ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

function M:entry(_)
  local fpath = get_hovered_item_path()
  if not fpath then
    fail "No file hovered or unknown format"
    return
  end

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
