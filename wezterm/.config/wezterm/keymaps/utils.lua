local M = {}

local Util = require("utils")
local wezterm = require("wezterm")
local act = wezterm.action

function M.split_nav(resize_or_move, mods, key, dir)
	local event = "SplitNav_" .. resize_or_move .. "_" .. dir

	wezterm.on(event, function(win, pane)
		local isTmux = pane:get_user_vars().PROG

		if isTmux and isTmux == "tmux" or isTmux == "tm" then
			-- pass the keys through to vim/nvim
			-- win:toast_notification("wezterm", mods .. " keys " .. key, nil, 4000)
			win:perform_action({ SendKey = { key = key, mods = mods } }, pane)
		else
			if Util.is_nvim(pane) then
				win:perform_action({ SendKey = { key = key, mods = mods } }, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { dir, 5 } }, pane)
				else
					-- win:toast_notification("wezterm", pane:get_foreground_process_name(), nil, 4000)
					local panes = pane:tab():panes_with_info()
					local is_zoomed = false
					for _, p in ipairs(panes) do
						if p.is_zoomed then
							is_zoomed = true
						end
					end
					if is_zoomed then
						dir = dir == "Up" or dir == "Right" and "Next" or "Prev"
						-- wezterm.log_info("dir: " .. dir)
					end
					win:perform_action({ ActivatePaneDirection = dir }, pane)
					win:perform_action({ SetPaneZoomState = is_zoomed }, pane)
				end
			end
		end
	end)
	return {
		key = key,
		mods = mods,
		action = wezterm.action.EmitEvent(event),
	}
end

-- local function active_pane(tab)
-- 	for _, item in ipairs(tab:panes_with_info()) do
-- 		if item.is_active then
-- 			return item.pane
-- 		end
-- 	end
-- end

-- function M.nav_numbers(key)
-- 	return {
-- 		key = key,
-- 		mods = "ALT",
-- 		action = wezterm.action_callback(function(window, pane)
-- 			if M.is_tmux(pane) then
-- 				window:perform_action({ SendKey = { key = key, mods = "ALT" } }, pane)
-- 			else
-- 				-- number pane wezterm itu dimulai dari 0, makanya di kurangin 1
-- 				window:perform_action(act.ActivateTab(tonumber(key) - 1), pane)
-- 			end
-- 		end),
-- 	}
-- end

-- local mods = wezterm.target_triple:find("windows") and "SHIFT|CTRL" or "SHIFT|SUPER"

-- local function strip_home_name(text)
-- 	local username = os.getenv("USER")
-- 	local clean_text = text:gsub("/home/" .. username, "~")
-- 	return clean_text
-- end

function M.spawn_toggle_pane(window, pane, direction)
	direction = direction or "Right"

	window:perform_action(
		act.SplitPane({
			direction = direction, -- Down
			-- command = { args = { "top" } },
			size = { Percent = 45 },
		}),
		pane
	)
	-- Constant.update_ctrl_f_panes({ pane_id = tonumber(pane:tab():active_pane():pane_id()),
	-- 	tab_id = pane:window():active_tab():tab_id(),
	-- 	run_as = "toggle_term",
	-- })
end

function M.spawn_file_manager(window, pane, percent_size)
	percent_size = percent_size or 15

	window:perform_action(
		act.SplitPane({
			direction = "Left",
			command = {
				args = {
					os.getenv("SHELL"), -- tanpa add `SHELL` ini, $PATH nya hilang. Check https://github.com/wez/wezterm/issues/3950
					-- "lfrun",
					"-c",
					"yazi",
				},
			},
			size = { Percent = 15 },
		}),
		pane
	)
	-- Constant.update_ctrl_f_panes({
	-- 	pane_id = tonumber(pane:tab():active_pane():pane_id()),
	-- 	tab_id = pane:window():active_tab():tab_id(),
	-- 	run_as = "file_manager",
	-- })
end

function M.get_back_to_filemanager(pane)
	local pane_id = pane:tab():get_pane_direction("Left")
	if pane_id == nil then
		return false
	end
	return true
end

function M.is_in_nvim(pane)
	return Util.get_foreground_process_name(pane, "nvim")
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
		act.SwitchToWorkspace({
			name = workspace,
		}),
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
