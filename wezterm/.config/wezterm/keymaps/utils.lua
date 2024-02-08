local M = {}

local Util = require("utils")
local wezterm = require("wezterm")
-- local act = wezterm.action

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
				-- win:toast_notification("wezterm", mods .. " keys " .. key, nil, 4000)
				win:perform_action({ SendKey = { key = key, mods = mods } }, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { dir, 3 } }, pane)
				else
					local panes = pane:tab():panes_with_info()
					local is_zoomed = false
					for _, p in ipairs(panes) do
						if p.is_zoomed then
							is_zoomed = true
						end
					end
					-- wezterm.log_info("is_zoomed: " .. tostring(is_zoomed))
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

return M
