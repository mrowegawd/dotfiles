local KeymapUtil = require("keymaps.utils")
-- local Constant = require("constant")

local Util = require("utils")

local wezterm = require("wezterm")
local act = wezterm.action

local mod_key = wezterm.target_triple:find("windows") and "SHIFT|CTRL" or "ALT"

return {
	-- ┌─────────────────────────────────────────────────────────┐
	-- │ PANE                                                    │
	-- └─────────────────────────────────────────────────────────┘
	{ -- smart split pane
		mods = mod_key,
		key = "Enter",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "Enter", mods = mod_key } }, pane)
			else
				local dim = pane:get_dimensions()
				if dim.pixel_height > dim.pixel_width then
					window:perform_action(act.SplitVertical({ domain = "CurrentPaneDomain" }), pane)
				else
					window:perform_action(act.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)
				end
			end
		end),
	},
	{ -- rotate pane
		mods = mod_key,
		key = "R",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "R", mods = mod_key } }, pane)
			else
				window:perform_action(wezterm.action.RotatePanes("Clockwise"), pane)
			end
		end),
	},
	{ -- scroll pane Down
		mods = mod_key,
		key = "PageDown",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "PageDown", mods = mod_key } }, pane)
			else
				window:perform_action(act.ScrollByPage(0.2), pane)
			end
		end),
	},
	{ -- scroll pane Up
		mods = mod_key,
		key = "PageUp",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "PageUp", mods = mod_key } }, pane)
			else
				window:perform_action(act.ScrollByPage(-0.2), pane)
			end
		end),
	},
	{ -- split pane horizontal
		mods = mod_key,
		key = "l",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "l", mods = mod_key } }, pane)
			else
				local pane_id = pane:tab():get_pane_direction("Right")
				if pane_id == nil then
					KeymapUtil.spawn_toggle_pane(window, pane)
				end
			end
		end),
	},
	{ -- split pane vertical
		mods = mod_key,
		key = "j",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "j", mods = mod_key } }, pane)
			else
				local pane_id = pane:tab():get_pane_direction("Down")
				if pane_id == nil then
					KeymapUtil.spawn_toggle_pane(window, pane, "Down")
				end
			end
		end),
	},

	KeymapUtil.split_nav("move", "CTRL", "h", "Left"),
	KeymapUtil.split_nav("move", "CTRL", "j", "Down"),
	KeymapUtil.split_nav("move", "CTRL", "k", "Up"),
	KeymapUtil.split_nav("move", "CTRL", "l", "Right"),
	-- { key = "h", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	-- { key = "j", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	-- { key = "k", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	-- { key = "l", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Right" }) },

	KeymapUtil.split_nav("resize", mod_key, "L", "Right"),
	KeymapUtil.split_nav("resize", mod_key, "H", "Left"),
	KeymapUtil.split_nav("resize", mod_key, "K", "Up"),
	KeymapUtil.split_nav("resize", mod_key, "J", "Down"),

	{ key = "1", mods = mod_key, action = act({ ActivateTab = 0 }) },
	{ key = "2", mods = mod_key, action = act({ ActivateTab = 1 }) },
	{ key = "3", mods = mod_key, action = act({ ActivateTab = 2 }) },
	{ key = "4", mods = mod_key, action = act({ ActivateTab = 3 }) },
	{ key = "5", mods = mod_key, action = act({ ActivateTab = 4 }) },
	{ key = "6", mods = mod_key, action = act({ ActivateTab = 5 }) },
	{ key = "7", mods = mod_key, action = act({ ActivateTab = 6 }) },
	{ key = "8", mods = mod_key, action = act({ ActivateTab = 7 }) },
	{ key = "9", mods = mod_key, action = act({ ActivateTab = 8 }) },

	-- ┌─────────────────────────────────────────────────────────┐
	-- │ TAB                                                     │
	-- └─────────────────────────────────────────────────────────┘
	{ -- open new tab
		mods = mod_key,
		key = "N",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "N", mods = mod_key } }, pane)
			else
				window:perform_action({ SpawnTab = "CurrentPaneDomain" }, pane)
			end
		end),
	},
	{ -- next tab
		mods = "ALT|CTRL",
		key = "l",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "l", mods = "ALT|CTRL" } }, pane)
			else
				window:perform_action({ ActivateTabRelative = 1 }, pane)
			end
		end),
	},
	{ -- prev tab
		mods = "ALT|CTRL",
		key = "h",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "h", mods = "ALT|CTRL" } }, pane)
			else
				window:perform_action({ ActivateTabRelative = -1 }, pane)
			end
		end),
	},
	{ -- move tab to the next
		mods = mod_key,
		key = "RightArrow",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "RightArrow", mods = mod_key } }, pane)
			else
				window:perform_action({ MoveTabRelative = 1 }, pane)
			end
		end),
	},
	{ -- move tab to the prev
		mods = mod_key,
		key = "LeftArrow",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "LeftArrow", mods = mod_key } }, pane)
			else
				window:perform_action({ MoveTabRelative = -1 }, pane)
			end
		end),
	},
	{ -- select list tabs
		mods = mod_key,
		key = "t",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) or KeymapUtil.is_in_yazi(pane) then
				window:perform_action({ SendKey = { key = "t", mods = mod_key } }, pane)
			else
				window:perform_action(act.ShowTabNavigator, pane)
			end
		end),
	},

	-- ┌─────────────────────────────────────────────────────────┐
	-- │ REMOVE                                                  │
	-- └─────────────────────────────────────────────────────────┘
	{
		mods = mod_key,
		key = "x",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "x", mods = mod_key } }, pane)
			else
				if KeymapUtil.is_in_nvim(pane) then
					window:perform_action({ SendKey = { key = "x", mods = mod_key } }, pane)
					return
				end
				window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
			end
		end),
	},
	{
		mods = "NONE",
		key = "q",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "q", mods = "NONE" } }, pane)
			else
				if KeymapUtil.is_in_nnn(pane) then
					window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
					return
				end

				if KeymapUtil.is_in_lf(pane) then
					window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
					return
				end

				if KeymapUtil.is_in_yazi(pane) then
					window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
					return
				end

				window:perform_action({ SendKey = { key = "q", mods = "NONE" } }, pane)
			end
		end),
	},

	-- ┌─────────────────────────────────────────────────────────┐
	-- │ MISC                                                    │
	-- └─────────────────────────────────────────────────────────┘
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "Clipboard" }) },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },
	{ key = "=", mods = "CTRL", action = "IncreaseFontSize" },
	{ key = "-", mods = "CTRL", action = "DecreaseFontSize" },
	{ key = "0", mods = "CTRL", action = "ResetFontSize" },
	{ mods = mod_key, key = "P", action = act.ActivateCommandPalette },
	{ -- enter copy mode
		mods = mod_key,
		key = "F5",
		action = act.Multiple({
			act.CopyMode("ClearSelectionMode"),
			act.ActivateCopyMode,
		}),
	},
	{ -- toggle zoom
		mods = mod_key,
		key = "m",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "m", mods = mod_key } }, pane)
			else
				window:perform_action(act.TogglePaneZoomState, pane)
			end
		end),
	},
	{ -- capture pane
		mods = mod_key,
		key = "c",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "c", mods = mod_key } }, pane)
			else
				window:perform_action(act.EmitEvent("trigger-nvim-with-scrollback"), pane)
			end
		end),
	},
	{ -- alt-w mirip seperti di tmux
		mods = mod_key,
		key = "w",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "w", mods = mod_key } }, pane)
			else
				window:perform_action(act.ShowTabNavigator, pane)
			end
		end),
	},
	{ -- open pane-tree
		mods = mod_key,
		key = "e",
		action = wezterm.action_callback(function(window, pane)
			-- window:toast_notification("wezterm", nil, 4000)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "e", mods = mod_key } }, pane)
			else
				if KeymapUtil.is_in_nnn(pane) or KeymapUtil.is_in_lf(pane) or KeymapUtil.is_in_yazi(pane) then
					window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
				end

				-- if KeymapUtil.is_in_nvim(pane) then
				-- 	if KeymapUtil.get_back_to_filemanager(pane) then
				-- 		if KeymapUtil.is_in_yazi(pane) then
				-- 			window:toast_notification("wezterm", "fasdf", nil, 4000)
				-- 			-- window:perform_action({ ActivatePaneDirection = "Right" }, pane)
				-- 			-- KeymapUtil.spawn_file_manager(window, pane)
				-- 			return
				-- 		else
				-- 			window:perform_action({ ActivatePaneDirection = "Left" }, pane)
				-- 		end
				-- 		return
				-- 	end
				-- end

				KeymapUtil.spawn_file_manager(window, pane)
			end
		end),
	},

	-- ┌─────────────────────────────────────────────────────────┐
	-- │ TERMINAL                                                │
	-- └─────────────────────────────────────────────────────────┘
	{ -- open terminal <a-f>
		mods = mod_key,
		key = "f",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "f", mods = mod_key } }, pane)
			else
				-- local panes = pane:tab():panes_with_info()

				if KeymapUtil.is_in_nvim(pane) then
					local pane_id = pane:tab():get_pane_direction("Right")
					if pane_id == nil then
						KeymapUtil.spawn_toggle_pane(window, pane)
					end
					window:perform_action({ ActivatePaneDirection = "Right" }, pane)
				elseif KeymapUtil.is_in_nnn(pane) then
					window:perform_action({ ActivatePaneDirection = "Right" }, pane)
				else
					window:perform_action({ ActivatePaneDirection = "Left" }, pane)
				end
			end
		end),
	},
}
