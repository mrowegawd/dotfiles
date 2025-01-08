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
					win:toast_notification("wezterm", pane:get_foreground_process_name(), nil, 4000)
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

	-- window:perform_action(
	-- 	act.SplitPane({
	-- 		direction = "Left",
	-- 		command = {
	-- 			args = {
	-- 				os.getenv("SHELL"), -- tanpa add `SHELL` ini, $PATH nya hilang. Check https://github.com/wez/wezterm/issues/3950
	-- 				"-c",
	-- 				"nnn",
	-- 			},
	-- 		},
	-- 		size = { Percent = 15 },
	-- 	}),
	-- 	pane
	-- )

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

function M.is_in_nvim(pane)
	return string.match(pane:get_foreground_process_name(), "nvim")
end

function M.is_in_nnn(pane)
	return string.match(pane:get_foreground_process_name(), "nnn")
end

function M.is_in_lf(pane)
	return string.match(pane:get_foreground_process_name(), "dash")
end

function M.is_in_yazi(pane)
	return string.match(pane:get_foreground_process_name(), "yazi")
end

return M
