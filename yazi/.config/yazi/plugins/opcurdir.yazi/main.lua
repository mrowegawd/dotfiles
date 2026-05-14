---@class ProcesCmd
---@field post_cmd string
---@field pre_cmd string

local function fail(s, ...)
  ---@diagnostic disable-next-line: undefined-global
  ya.notify { title = "Opcurdir", content = string.format(s, ...), timeout = 5, level = "info" }
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ UTILS                                                    ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

---@diagnostic disable-next-line: undefined-global
local state = ya.sync(function()
  ---@diagnostic disable-next-line: undefined-global
  return cx.active.current.cwd
end)

local function is_in_tmux()
  return os.getenv "TMUX" ~= nil
end

local function is_in_wezterm()
  return os.getenv "TERMINAL" == "wezterm"
end

---@param cmd string
---@param args table
---@return string | nil
local function get_cmd_output(cmd, args)
  ---@diagnostic disable-next-line: undefined-global
  local child, err = Command(cmd):arg(args):stdout(Command.PIPED):stderr(Command.INHERIT):output()
  if err or not child then
    fail("Command failed: %s — %s", cmd, tostring(err))
    return nil
  end
  return (child.stdout or ""):gsub("[\r\n]+$", "")
end

local function run(cmd)
  os.execute(cmd)
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ JSON HELPERS                                             ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

local JSON_FILE = "/tmp/tmux-main-layout-workspaces.json"

---@param session_id string
---@param window_id string
---@param field string
---@return string
local function get_json_field(session_id, window_id, field)
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
    JSON_FILE,
  }) or ""
end

---@param session_id string
---@param window_id string
---@param field string
---@param value string
local function update_json_field(session_id, window_id, field, value)
  run(
    string.format(
      "jq --arg s %q --arg w %q --arg f %q --arg v %q '.[$s][$w][$f] = $v' %s > /tmp/tmux-ws-tmp.json && mv /tmp/tmux-ws-tmp.json %s",
      session_id,
      window_id,
      field,
      value,
      JSON_FILE,
      JSON_FILE
    )
  )
end

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
  if err or not child or not child.stdout then
    return false
  end
  for line in child.stdout:gmatch "[^\r\n]+" do
    if line == pane_id then
      return true
    end
  end
  return false
end

-- Resolve main_pane_id dari JSON, buat entry baru kalau belum ada
---@return string | nil
local function resolve_main_pane_id()
  local session_id = get_cmd_output("sh", { "-c", "tmux display-message -p '#S'" })
  local window_id = get_cmd_output("sh", { "-c", "tmux display-message -p '#I'" })

  if not session_id or not window_id then
    fail "Cannot determine tmux session/window"
    return nil
  end

  local pane_id = get_json_field(session_id, window_id, "main_pane_id")

  if pane_id ~= "" and is_pane_exists(pane_id) then
    return pane_id
  end

  -- main_pane_id tidak ada atau stale → fallback: cari pane kanan dari yazi
  -- Script ini tidak bisa buat main_pane_id karena itu urusan tm-toggle-pane,
  -- jadi fallbacknya pakai pakai pane di sebelah kanan sebagai target
  local yazi_pane = os.getenv "TMUX_PANE"
  if not yazi_pane then
    fail "TMUX_PANE env not found"
    return nil
  end

  local right_pane = get_cmd_output("sh", {
    "-c",
    "tmux display-message -p -t "
      .. yazi_pane
      .. " '#{pane_id}' 2>/dev/null; tmux select-pane -t "
      .. yazi_pane
      .. " -R 2>/dev/null; tmux display-message -p '#{pane_id}'; tmux select-pane -t "
      .. yazi_pane
      .. " 2>/dev/null",
  })

  right_pane = get_cmd_output("sh", {
    "-c",
    string.format(
      [[
    orig="%s"
    tmux select-pane -t "$orig" -R 2>/dev/null
    new=$(tmux display-message -p '#{pane_id}')
    tmux select-pane -t "$orig" 2>/dev/null
    echo "$new"
  ]],
      yazi_pane
    ),
  })

  if not right_pane or right_pane == "" or right_pane == yazi_pane then
    fail "No pane found to the right. Please run tm-toggle-pane first to create the layout."
    return nil
  end

  update_json_field(session_id, window_id, "main_pane_id", right_pane)
  return right_pane
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ PROCESS HELPERS                                          ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

---@param pane_id string
---@return string
local function get_pane_process(pane_id)
  return get_cmd_output("tmux", { "display-message", "-p", "-t", pane_id, "#{pane_current_command}" }) or ""
end

---@param pane_id string
---@param target_process string
---@param max_retries? integer
---@return boolean
local function wait_for_process(pane_id, target_process, max_retries)
  max_retries = max_retries or 20
  for _ = 1, max_retries do
    local proc = get_pane_process(pane_id)
    if proc == target_process then
      return true
    end
    run "sleep 0.15"
  end
  return false
end

---@param pane_id string
---@param target_cwd string
---@param max_retries? integer
---@return boolean
local function wait_for_cwd(pane_id, target_cwd, max_retries)
  max_retries = max_retries or 20
  for _ = 1, max_retries do
    local cwd = get_cmd_output("tmux", { "display-message", "-p", "-t", pane_id, "#{pane_current_path}" }) or ""
    if cwd == target_cwd then
      return true
    end
    run "sleep 0.15"
  end
  return false
end

---@param pane_id string
local function close_nvim_if_running(pane_id)
  local proc = get_pane_process(pane_id)
  if proc ~= "nvim" then
    return
  end

  run("tmux send-keys -t " .. pane_id .. " Escape ':qa!' Enter")

  local ok = wait_for_process(pane_id, "zsh")
  if not ok then
    fail("Timeout waiting for nvim to close on pane %s", pane_id)
  end
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ OPEN WITH TMUX                                           ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

---@param cwd string
local function open_with_tmux(cwd)
  -- local yazi_pane = os.getenv "TMUX_PANE"

  local target_pane = resolve_main_pane_id()
  if not target_pane then
    return
  end

  close_nvim_if_running(target_pane) -- close nvim if still open
  run("tmux send-keys -t " .. target_pane .. " 'cd " .. cwd .. "' Enter")

  local ok = wait_for_cwd(target_pane, cwd)
  if not ok then
    fail("Timeout waiting for cd to complete on pane %s (target: %s)", target_pane, cwd)
    return
  end

  run("tmux send-keys -t " .. target_pane .. " 'nvim' Enter")
  run("tmux select-pane -t " .. target_pane)
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ OPEN WITH WEZTERM                                        ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

local function wezterm_send(pane_id, text, with_enter)
  local cmd = 'echo "'
    .. text
    .. (with_enter and "\r" or "")
    .. '" | wezterm cli send-text --pane-id '
    .. pane_id
    .. " --no-paste"
  run(cmd)
end

---@param cwd string
local function open_with_wezterm(cwd)
  local pane_id = get_cmd_output("wezterm", { "cli", "get-pane-direction", "Left" })
  if not pane_id or pane_id == "" then
    fail "No pane found to the Left. Please create the layout first."
    return
  end

  local prog = get_cmd_output("sh", {
    "-c",
    "wezterm cli list | awk -v pane_id=" .. pane_id .. " '$3==pane_id { print $6 }'",
  })

  if prog == "nvim" then
    wezterm_send(pane_id, ":qa!", true)
    run "sleep 0.5"
  end

  wezterm_send(pane_id, "cd " .. cwd, true)
  run "sleep 0.3"

  wezterm_send(pane_id, "nvim", true)
  run "sleep 0.3"

  -- Kembali ke yazi
  -- run("wezterm cli activate-pane-direction --pane-id " .. pane_id .. " Left")

  -- Fokus ke pane nvim, bukan balik ke yazi
  run("wezterm cli activate-pane --pane-id " .. pane_id)
end

-- ┌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┐
-- ╎ ENTRY                                                    ╎
-- └╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┘

return {
  entry = function()
    local cwd = tostring(state())

    if is_in_tmux() then
      open_with_tmux(cwd)
    elseif is_in_wezterm() then
      open_with_wezterm(cwd)
    else
      fail "Only tmux or wezterm is supported"
    end
  end,
}
