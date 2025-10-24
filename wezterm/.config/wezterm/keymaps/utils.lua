local M = {}

local Util = require "utils"
local wezterm = require "wezterm"
local act = wezterm.action

function M.split_nav(resize_or_move, mods, key, dir)
  local event = "SplitNav_" .. resize_or_move .. "_" .. dir

  wezterm.on(event, function(window, pane)
    if M.is_in_tmux(pane) then
      window:perform_action({ SendKey = { key = key, mods = mods } }, pane)
    else
      local panes = pane:tab():panes_with_info()
      local is_zoomed = false
      for _, p in ipairs(panes) do
        if p.is_zoomed then
          is_zoomed = true
        end
      end

      if M.is_in_nvim(pane) then
        window:perform_action({ SendKey = { key = key, mods = mods } }, pane)
        return
      end

      if resize_or_move == "resize" then
        window:perform_action({ AdjustPaneSize = { dir, 5 } }, pane)
        return
      end

      if not is_zoomed then
        window:perform_action({ ActivatePaneDirection = dir }, pane)
      end
    end
  end)
  return {
    key = key,
    mods = mods,
    action = wezterm.action.EmitEvent(event),
  }
end

function M.nav_numbers(key)
  return {
    key = key,
    mods = "ALT",
    action = wezterm.action_callback(function(window, pane)
      if M.is_in_tmux(pane) then
        window:perform_action({ SendKey = { key = key, mods = "ALT" } }, pane)
      else
        -- number pane wezterm itu dimulai dari 0, makanya di kurangin 1
        window:perform_action(act.ActivateTab(tonumber(key) - 1), pane)
      end
    end),
  }
end

function M.spawn_toggle_pane(window, pane, direction, percent_size)
  percent_size = percent_size or 35
  direction = direction or "Right"

  window:perform_action(
    act.SplitPane {
      direction = direction, -- Down
      size = { Percent = percent_size },
    },
    pane
  )
  -- Constant.update_ctrl_f_panes({ pane_id = tonumber(pane:tab():active_pane():pane_id()),
  -- 	tab_id = pane:window():active_tab():tab_id(),
  -- 	run_as = "toggle_term",
  -- })
end

function M.spawn_file_manager(window, pane, percent_size, cmd_file_manager)
  cmd_file_manager = cmd_file_manager or "yazi" -- nnn, yazi, ranger
  percent_size = percent_size or 20

  window:perform_action(
    act.SplitPane {
      direction = "Right",
      command = {
        args = {
          os.getenv "SHELL", -- tanpa di add `SHELL` ini, $PATH nya hilang. Check https://github.com/wez/wezterm/issues/3950
          "-c",
          cmd_file_manager,
        },
      },
      size = { Percent = percent_size },
    },
    pane
  )
  -- Constant.update_ctrl_f_panes({
  -- 	pane_id = tonumber(pane:tab():active_pane():pane_id()),
  -- 	tab_id = pane:window():active_tab():tab_id(),
  -- 	run_as = "file_manager",
  -- })
end

function M.spawn_command_with_split(window, pane, percent_size, cmd)
  cmd = cmd or "ls"
  percent_size = percent_size or 20

  window:perform_action(
    act.SplitPane {
      direction = "Right",
      command = {
        args = {
          os.getenv "SHELL",
          "-c",
          cmd,
        },
      },
      size = { Percent = percent_size },
    },
    pane
  )
end

function M.spawn_child_process(args)
  wezterm.background_child_process(args)
end

function M.is_left_pane_exists(pane)
  local pane_id = pane:tab():get_pane_direction "Left"
  if pane_id == nil then
    return false
  end
  return true
end

function M.is_right_pane_exists(pane)
  local pane_id = pane:tab():get_pane_direction "Right"
  if pane_id == nil then
    return false
  end
  return true
end

function M.is_pane_zoomed(pane)
  local panes = pane:tab():panes_with_info()
  local is_zoomed = false
  for _, p in ipairs(panes) do
    if p.is_zoomed then
      is_zoomed = true
    end
  end
  return is_zoomed
end

function M.is_in_tmux(pane)
  -- TAKEN FROM: https://wezfurlong.org/wezterm/recipes/passing-data.html#user-vars
  -- following file: aliases.basrc
  local isTmux = pane:get_user_vars().PROG
  if isTmux and isTmux == "tmux" or isTmux == "tm" then
    return true
  end

  return false
end

function M.is_in_nvim(pane)
  -- or pane:get_user_vars().IS_NVIM == "true"
  return pane:get_foreground_process_name():find "n?vim"
end

function M.is_in_nnn(pane)
  return Util.get_foreground_process_name(pane, "nnn")
end

function M.is_in_lf(pane)
  return Util.get_foreground_process_name(pane, "dash")
end

function M.is_in_yazi(pane)
  return Util.get_foreground_process_name(pane, "yazi")
end

-- Taken from: https://github.com/tjex/wezterm-conf/blob/90bd2219e314633c688102b3803a5299b70df68d/functions/funcs.lua
function M.switch_workspace(window, pane, workspace)
  local current_workspace = window:active_workspace()
  if current_workspace == workspace then
    return
  end

  window:perform_action(
    act.SwitchToWorkspace {
      name = workspace,
    },
    pane
  )
  wezterm.GLOBAL.previous_workspace = current_workspace
end

function M.switch_to_previous_workspace(window, pane)
  local current_workspace = window:active_workspace()
  local workspace = wezterm.GLOBAL.previous_workspace

  if current_workspace == workspace or wezterm.GLOBAL.previous_workspace == nil then
    return
  end

  M.switch_workspace(window, pane, workspace)
end

return M
