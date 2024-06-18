local KeymapUtil = require("keymaps.utils")
-- local Constant = require("constant")

local Util = require("utils")

local wezterm = require("wezterm")
local act = wezterm.action

return {
	-- ┌─────────────────────────────────────────────────────────┐
	-- │ PANE                                                    │
	-- └─────────────────────────────────────────────────────────┘
	--
	{
		mods = "ALT",
		key = "Enter",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "Enter", mods = "ALT" } }, pane)
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
	KeymapUtil.split_nav("move", "ALT", "h", "Left"),
	KeymapUtil.split_nav("move", "ALT", "j", "Down"),
	KeymapUtil.split_nav("move", "ALT", "k", "Up"),
	KeymapUtil.split_nav("move", "ALT", "l", "Right"),

	KeymapUtil.split_nav("resize", "ALT", "L", "Right"),
	KeymapUtil.split_nav("resize", "ALT", "H", "Left"),
	KeymapUtil.split_nav("resize", "ALT", "K", "Up"),
	KeymapUtil.split_nav("resize", "ALT", "J", "Down"),

	{ key = "1", mods = "ALT", action = act({ ActivateTab = 0 }) },
	{ key = "2", mods = "ALT", action = act({ ActivateTab = 1 }) },
	{ key = "3", mods = "ALT", action = act({ ActivateTab = 2 }) },
	{ key = "4", mods = "ALT", action = act({ ActivateTab = 3 }) },
	{ key = "5", mods = "ALT", action = act({ ActivateTab = 4 }) },
	{ key = "6", mods = "ALT", action = act({ ActivateTab = 5 }) },
	{ key = "7", mods = "ALT", action = act({ ActivateTab = 6 }) },
	{ key = "8", mods = "ALT", action = act({ ActivateTab = 7 }) },
	{ key = "9", mods = "ALT", action = act({ ActivateTab = 8 }) },

	{ -- Scroll pane Down
		mods = "ALT",
		key = "PageDown",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "PageDown", mods = "ALT" } }, pane)
			else
				window:perform_action(act.ScrollByPage(0.2), pane)
			end
		end),
	},
	{ -- Scroll pane Up
		mods = "ALT",
		key = "PageUp",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "PageUp", mods = "ALT" } }, pane)
			else
				window:perform_action(act.ScrollByPage(-0.2), pane)
			end
		end),
	},

	-- ┌─────────────────────────────────────────────────────────┐
	-- │ TAB                                                     │
	-- └─────────────────────────────────────────────────────────┘
	-- { key = "N", mods = "ALT", action = act({ SpawnTab = "CurrentPaneDomain" }) },
	{
		mods = "ALT",
		key = "N",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "N", mods = "ALT" } }, pane)
			else
				window:perform_action({ SpawnTab = "CurrentPaneDomain" }, pane)
			end
		end),
	},
	{
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
	{
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
	{
		mods = "ALT",
		key = "RightArrow",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "RightArrow", mods = "ALT" } }, pane)
			else
				window:perform_action({ MoveTabRelative = 1 }, pane)
			end
		end),
	},
	{
		mods = "ALT",
		key = "LeftArrow",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "LeftArrow", mods = "ALT" } }, pane)
			else
				window:perform_action({ MoveTabRelative = -1 }, pane)
			end
		end),
	},
	{ -- rotate pane
		mods = "ALT",
		key = "R",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "R", mods = "ALT" } }, pane)
			else
				window:perform_action(wezterm.action.RotatePanes("Clockwise"), pane)
			end
		end),
	},

	-- ┌─────────────────────────────────────────────────────────┐
	-- │ REMOVE                                                  │
	-- └─────────────────────────────────────────────────────────┘
	{
		mods = "ALT",
		key = "x",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "x", mods = "ALT" } }, pane)
			else
				if KeymapUtil.is_in_nvim(pane) then
					window:perform_action({ SendKey = { key = "x", mods = "ALT" } }, pane)
					return
				end
				window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
			end
		end),
	},
	-- {
	-- 	mods = "ALT",
	-- 	key = "X",
	-- 	action = wezterm.action_callback(function(window, pane)
	-- 		if Util.is_tmux(pane) then
	-- 			window:perform_action({ SendKey = { key = "X", mods = "ALT" } }, pane)
	-- 		else
	-- 			if KeymapUtil.is_in_nnn(pane) then
	-- 				window:perform_action({ SendKey = { key = "X", mods = "ALT" } }, pane)
	-- 				return
	-- 			end
	--
	-- 			if KeymapUtil.is_in_lf(pane) then
	-- 				window:perform_action({ SendKey = { key = "X", mods = "ALT" } }, pane)
	-- 				return
	-- 			end
	--
	-- 			if KeymapUtil.is_in_yazi(pane) then
	-- 				window:perform_action({ SendKey = { key = "X", mods = "ALT" } }, pane)
	-- 				return
	-- 			end
	--
	-- 			window:perform_action({ CloseCurrentTab = { confirm = true } }, pane)
	-- 		end
	-- 	end),
	-- },
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
	{ key = "Home", mods = "CTRL", action = "ResetFontSize" },

	{ mods = "ALT", key = "P", action = act.ActivateCommandPalette },

	{ -- enter copy mode
		key = "F5",
		mods = "ALT",
		action = act.Multiple({
			act.CopyMode("ClearSelectionMode"),
			act.ActivateCopyMode,
		}),
	},
	{ -- toggle zoom
		mods = "ALT",
		key = "m",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "m", mods = "ALT" } }, pane)
			else
				window:perform_action(act.TogglePaneZoomState, pane)
			end
		end),
	},
	{ -- capture pane
		mods = "ALT",
		key = "c",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "c", mods = "ALT" } }, pane)
			else
				window:perform_action(act.EmitEvent("trigger-nvim-with-scrollback"), pane)
			end
		end),
	},
	{ -- alt-w mirip seperti di tmux
		mods = "ALT",
		key = "w",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "w", mods = "ALT" } }, pane)
			else
				window:perform_action(act.ShowTabNavigator, pane)
			end
		end),
	},
	{ -- open pane-tree
		mods = "ALT",
		key = "e",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "e", mods = "ALT" } }, pane)
			else
				local panes = pane:tab():panes_with_info()

				if #panes == 1 then
					-- window:toast_notification("wezterm", os.getenv("TERM_FILEMANAGER"), nil, 4000)
					KeymapUtil.spawn_file_manager(window, pane)
				else
					-- window:toast_notification("wezterm", os.getenv("TERM_FILEMANAGER"), nil, 4000)
					if KeymapUtil.is_in_nnn(pane) then
						window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
						window:perform_action({ ActivatePaneDirection = "Right" }, pane)
						return
					end

					if KeymapUtil.is_in_lf(pane) then
						window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
						window:perform_action({ ActivatePaneDirection = "Right" }, pane)
						return
					end

					if KeymapUtil.is_in_nvim(pane) then
						window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
						KeymapUtil.spawn_file_manager(window, pane)
						return
					end

					if KeymapUtil.is_in_yazi(pane) then
						window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
						KeymapUtil.spawn_file_manager(window, pane)
						return
					end
				end
			end
		end),
	},

	-- ┌─────────────────────────────────────────────────────────┐
	-- │ TERMINAL                                                │
	-- └─────────────────────────────────────────────────────────┘
	{
		mods = "ALT",
		key = "f",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "f", mods = "ALT" } }, pane)
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
