---@class ProcesCmd
---@field get_process_cmd table<string>
---@field post_cmd string
---@field pre_cmd string
---@field is_cwd boolean

local function fail(s, ...)
  ---@diagnostic disable-next-line: undefined-global
  ya.notify { title = "Opcurdir", content = string.format(s, ...), timeout = 5, level = "info" }
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

---@param process? string
---@param cmds? table<string>
---@return string | nil
local function check_process_cmd(process, cmds)
  cmds = cmds or { "display-message", "-p", "'#{pane_current_command}'" }
  process = process or ""

  local output = send_command("tmux", cmds)
  if not output then
    if #process > 0 then
      fail("Something went wrong, check your command " .. process)
    end
    fail "something went wrong, check your command "
    return
  end

  local get_process_name = tostring(output:gsub("'", ""))
  get_process_name = get_process_name:gsub("\n$", "")
  return get_process_name
end

---@param mode ProcesCmd[]
local function force_close_process_name(mode)
  local get_process_name = check_process_cmd()
  if not get_process_name then
    return
  end

  for idx, cmd in pairs(mode) do
    if get_process_name == idx then
      os.execute(cmd.post_cmd)

      for _ = 1, 10 do
        local process_name = check_process_cmd(cmd.pre_cmd)
        if not process_name then
          break
        end

        if process_name == cmd.pre_cmd then
          break
        end

        os.execute "sleep 0.5"
      end
    end

    -- if cmd.is_cwd then
    --   if get_process_name == "zsh" then
    --     os.execute(cmd.post_cmd)
    --
    --     for _ = 1, 10 do
    --       local process_name = check_process_cmd(cmd.pre_cmd, cmd.get_process_cmd)
    --       if not process_name then
    --         break
    --       end
    --
    --       if string.find(process_name, cmd.pre_cmd) then
    --         -- fail(process_name)
    --         -- fail(cmd.pre_cmd)
    --         break
    --       end
    --
    --       os.execute "sleep 0.5"
    --     end
    --   end
    -- end
  end
end

---@param cwd string
local function open_with_tmux(cwd)
  os.execute [[tmux select-pane -R]]

  ---@type ProcesCmd[]
  local process_command_to_close = {
    ["nvim"] = {
      get_process_cmd = { "display-message", "-p", "'#{pane_current_command}'" },
      post_cmd = [[tmux send-keys Escape ":qa!" Enter]],
      pre_cmd = "zsh",
      is_cwd = false,
    },
    -- ["zsh"] = {
    --   get_process_cmd = { "display-message", "-p", "'#{pane_current_path}'" },
    --   post_cmd = [[tmux send-keys "cd ]] .. cwd .. [[" Enter]],
    --   pre_cmd = cwd,
    --   is_cwd = true,
    -- },
  }

  force_close_process_name(process_command_to_close)

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
