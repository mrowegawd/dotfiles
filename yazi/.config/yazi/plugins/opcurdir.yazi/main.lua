local function fail(s, ...)
  ---@diagnostic disable-next-line: undefined-global
  ya.notify { title = "Opcurdir", content = string.format(s, ...), timeout = 5, level = "error" }
end

---@return string
---@diagnostic disable-next-line: undefined-global
local state = ya.sync(function()
  ---@diagnostic disable-next-line: undefined-global
  return cx.active.current.cwd
end)

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

---@param pane_id string
---@param is_tmux? boolean
local function send_enter_with(pane_id, is_tmux)
  is_tmux = is_tmux or false

  local enter_cmd
  if not is_tmux then
    -- kadang butuh `$\r` atau `\r` saja, tak tahu tapi mudah2an bisa
    enter_cmd = "wezterm cli send-text --pane-id " .. pane_id .. " --no-paste '\r'"
  else
    enter_cmd = ""
    fail "The 'send_enter_with' command with tmux is not implemented yet or not used"
    return
  end

  if enter_cmd then
    os.execute(enter_cmd)
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

---@param cmd string
---@param args table
---@return string | nil
local function send_command(cmd, args)
  local child, err =
    ---@diagnostic disable-next-line: undefined-global
    Command(cmd):arg(args):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

  if not child then
    return fail("check pane_current_command went wrong", err)
  end

  local output, _ = child:wait_with_output()
  if not output then
    fail("No output! %s", err)
    return
  elseif not output.status.success and output.status.code ~= 130 then
    fail("something went wrong %s", output.status.code)
    return
  end

  return output.stdout:gsub("\n$", "")
end

---@param cwd string
local function open_with_tmux(cwd)
  os.execute [[tmux select-pane -R]]

  local output = send_command("tmux", { "display-message", "-p", "'#{pane_current_command}'" })
  if not output then
    fail("OPEN_WITH_TMUX", "something went wrong, check your command")
    return
  end

  local get_process_name = tostring(output:gsub("'", ""))
  get_process_name = get_process_name:gsub("\n$", "")

  if get_process_name == "nvim" then
    local commandquit = [[tmux send-keys ":qa!" Enter]]
    os.execute(commandquit)
  end

  os.execute "sleep 0.3"

  local command = [[tmux send-keys "cd ]] .. cwd .. [[" Enter]]
  os.execute(command)

  os.execute "sleep 0.5"

  local openeditor = [[tmux send-keys "nvim" Enter]]
  os.execute(openeditor)
end

---@param cwd string
local function open_with_wezterm(cwd)
  local pane_id_right = get_output_string_cmd("wezterm", { "cli", "get-pane-direction", "Left" })
  if pane_id_right == "" or #pane_id_right == 0 or pane_id_right == nil then
    fail "Get pane `pane_id_right` failed.\nCheck your `args` commands"
    return
  end

  local get_process_name = get_output_string_cmd(
    "sh",
    { "-c", "wezterm cli list | awk -v pane_id=" .. pane_id_right .. " '$3==pand_id { print $6 }'" }
  )

  if get_process_name == "nvim" then
    os.execute('echo ":qa!" | wezterm cli send-text --pane-id ' .. pane_id_right .. " --no-paste")
    os.execute "sleep 0.5"
    send_enter_with(pane_id_right)
  end

  local cd_cmd = "echo 'cd " .. cwd .. "' | wezterm cli send-text --pane-id " .. pane_id_right
  os.execute(cd_cmd)
  send_enter_with(pane_id_right)

  local open_nvim = "echo 'nvim' | wezterm cli send-text --pane-id " .. pane_id_right
  os.execute(open_nvim)
  os.execute "sleep 0.5"
  send_enter_with(pane_id_right)

  local jump_to_pane = "wezterm cli activate-pane-direction --pane-id " .. pane_id_right .. " Left"
  os.execute(jump_to_pane)
end

return {
  entry = function()
    local cwd = tostring(state())

    if is_in_tmux() then
      open_with_tmux(cwd)
    elseif is_in_wezterm() then
      open_with_wezterm(cwd)
    else
      fail "only support for tmux or wezterm terminal"
    end
  end,
}
