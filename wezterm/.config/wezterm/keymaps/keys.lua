local KeymapUtil = require("keymaps.utils")
-- local Constant = require("constant")

local wezterm = require("wezterm")
local act = wezterm.action

local mod_key = wezterm.target_triple:find("windows") and "SHIFT|CTRL" or "ALT"

-- Load the plugin
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

return {

	-- ┌─────────────────────────────────────────────────────────┐
	-- │ PANE                                                    │
	-- └─────────────────────────────────────────────────────────┘
	-- { -- smart split pane
	-- 	key = "Enter",
	-- 	mods = mod_key,
	-- 	action = wezterm.action_callback(function(window, pane)
	-- 		if KeymapUtil.is_in_tmux (pane) then
	-- 			window:perform_action({ SendKey = { key = "Enter", mods = mod_key } }, pane)
	-- 		else
	-- 			local dim = pane:get_dimensions()
	-- 			if dim.pixel_height > dim.pixel_width then
	-- 				window:perform_action(act.SplitVertical({ domain = "CurrentPaneDomain" }), pane)
	-- 			else
	-- 				window:perform_action(act.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)
	-- 			end
	-- 		end
	-- 	end),
	-- },
	{ -- rotate pane
		key = "R",
		mods = mod_key,
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "R", mods = mod_key } }, pane)
			else
				window:perform_action(wezterm.action.RotatePanes("Clockwise"), pane)
			end
		end),
	},
	{ -- scroll pane down
		key = "PageDown",
		mods = mod_key,
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "PageDown", mods = mod_key } }, pane)
			else
				window:perform_action(act.ScrollByPage(0.2), pane)
			end
		end),
	},
	{ -- scroll pane up
		mods = mod_key,
		key = "PageUp",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "PageUp", mods = mod_key } }, pane)
			else
				window:perform_action(act.ScrollByPage(-0.2), pane)
			end
		end),
	},
	{ -- split pane horizontal
		key = "l",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "l", mods = "LEADER" } }, pane)
			else
				local pane_id = pane:tab():get_pane_direction("Right")
				if pane_id == nil then
					KeymapUtil.spawn_toggle_pane(window, pane)
				end
			end
		end),
	},
	{ -- split pane vertical
		key = "j",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "j", mods = "LEADER" } }, pane)
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

	-- ╭─────────────────────────────────────────────────────────╮
	-- │ WINDOW                                                  │
	-- ╰─────────────────────────────────────────────────────────╯
	{ -- new window
		key = "N",
		mods = mod_key,
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "N", mods = mod_key } }, pane)
			else
				window:perform_action({ SpawnTab = "CurrentPaneDomain" }, pane)
			end
		end),
	},
	{ -- next window
		mods = "ALT|CTRL",
		key = "l",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "l", mods = "ALT|CTRL" } }, pane)
			else
				window:perform_action({ ActivateTabRelative = 1 }, pane)
			end
		end),
	},
	{ -- prev window
		mods = "ALT|CTRL",
		key = "h",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "h", mods = "ALT|CTRL" } }, pane)
			else
				window:perform_action({ ActivateTabRelative = -1 }, pane)
			end
		end),
	},
	{ -- move the window to the next
		mods = mod_key,
		key = "RightArrow",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "RightArrow", mods = mod_key } }, pane)
			else
				window:perform_action({ MoveTabRelative = 1 }, pane)
			end
		end),
	},
	{ -- move the window to the prev
		mods = mod_key,
		key = "LeftArrow",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "LeftArrow", mods = mod_key } }, pane)
			else
				window:perform_action({ MoveTabRelative = -1 }, pane)
			end
		end),
	},
	{ -- select lists window
		mods = mod_key,
		key = "t",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) or KeymapUtil.is_in_yazi(pane) then
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
		key = "x",
		mods = mod_key,
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
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
		key = "q",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
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
		key = "F5",
		mods = mod_key,
		action = act.Multiple({
			act.CopyMode("ClearSelectionMode"),
			act.ActivateCopyMode,
		}),
	},
	{ -- toggle zoom
		key = "m",
		mods = mod_key,
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "m", mods = mod_key } }, pane)
			else
				window:perform_action(act.TogglePaneZoomState, pane)
			end
		end),
	},
	{ -- capture pane
		key = "c",
		mods = mod_key,
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "c", mods = mod_key } }, pane)
			else
				window:perform_action(act.EmitEvent("trigger-nvim-with-scrollback"), pane)
			end
		end),
	},
	{ -- reset size pane
		key = "w",
		mods = mod_key,
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "w", mods = mod_key } }, pane)
			else
				window:toast_notification("wezterm", "Reset pane size: not implemented yet", nil, 4000)
				-- window:perform_action(act.ShowTabNavigator, pane)
			end
		end),
	},
	{ -- open file tree manager
		key = "e",
		mods = mod_key,
		action = wezterm.action_callback(function(window, pane)
			-- window:toast_notification("wezterm", nil, 4000)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "e", mods = mod_key } }, pane)
			else
				if KeymapUtil.is_in_nnn(pane) or KeymapUtil.is_in_lf(pane) or KeymapUtil.is_in_yazi(pane) then
					window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
					return
				end

				-- Handle jika cursor masih berada di nvim tetapi yazi sudah terbuka
				if KeymapUtil.is_left_pane_exists(pane) then
					window:perform_action({ ActivatePaneDirection = "Left" }, pane)
					return
				end

				KeymapUtil.spawn_file_manager(window, pane, 15, "yazi")
			end
		end),
	},
	{ -- open lazygit
		key = "g",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "g", mods = "LEADER" } }, pane)
			else
				local cwd_uri = pane:get_current_working_dir()
				-- window:toast_notification("wezterm", cwd_uri.file_path, nil, 4000)
				KeymapUtil.spawn_child_process({
					"wezterm",
					"start",
					"--cwd",
					cwd_uri.file_path,
					"--class",
					"if-select",
					"lazygit",
					"--use-config-file",
					wezterm.home_dir
						.. "/.config/lazygit/config.yml,"
						.. wezterm.home_dir
						.. "/.config/lazygit/theme/fla.yml",
				})
			end
		end),
	},
	{ -- open lazydocker
		key = "d",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "d", mods = "LEADER" } }, pane)
			else
				KeymapUtil.spawn_child_process({
					"wezterm",
					"start",
					"--cwd",
					".",
					"--class",
					"if-select",
					"lazydocker",
				})
			end
		end),
	},
	{ -- open btop
		key = "h",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "b", mods = "LEADER" } }, pane)
			else
				local cwd_uri = pane:get_current_working_dir()
				KeymapUtil.spawn_child_process({
					"wezterm",
					"start",
					"--cwd",
					cwd_uri.file_path,
					"--class",
					"if-select",
					"btop",
				})
			end
		end),
	},
	{ -- open newsboat
		key = "N",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "N", mods = "LEADER" } }, pane)
			else
				local cwd_uri = pane:get_current_working_dir()
				KeymapUtil.spawn_child_process({
					"wezterm",
					"start",
					"--cwd",
					cwd_uri.file_path,
					"--class",
					"if-select",
					"proxychains",
					"-q",
					"newsboat",
				})
			end
		end),
	},
	{ -- open rkill
		key = "k",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "k", mods = "LEADER" } }, pane)
			else
				-- KeymapUtil.spawn_command_with_split(window, pane, 80, "rkll")
				local cwd_uri = pane:get_current_working_dir()
				KeymapUtil.spawn_child_process({
					"wezterm",
					"start",
					"--cwd",
					cwd_uri.file_path,
					"--class",
					"if-select",
					"rkll",
				})
			end
		end),
	},
	{ -- open calc
		key = "c",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "c", mods = "LEADER" } }, pane)
			else
				-- local cwd_uri = pane:get_current_working_dir()
				-- KeymapUtil.spawn_command_with_split(window, pane, 80, "calc")
				local cwd_uri = pane:get_current_working_dir()
				KeymapUtil.spawn_child_process({
					"wezterm",
					"start",
					"--cwd",
					cwd_uri.file_path,
					"--class",
					"if-select",
					"calc",
				})
			end
		end),
	},

	-- ╭─────────────────────────────────────────────────────────╮
	-- │ SESSION                                                 │
	-- ╰─────────────────────────────────────────────────────────╯
	{ -- select session
		key = "y",
		mods = mod_key,
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "y", mods = mod_key } }, pane)
			else
				window:perform_action(workspace_switcher.switch_workspace(), pane)
			end
		end),
	},
	{ -- last session
		key = "b",
		mods = mod_key,
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "b", mods = mod_key } }, pane)
			else
				KeymapUtil.switch_to_previous_workspace(window, pane)
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
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "f", mods = mod_key } }, pane)
			else
				if KeymapUtil.is_in_nvim(pane) then
					local pane_id = pane:tab():get_pane_direction("Down")
					if pane_id == nil then
						KeymapUtil.spawn_toggle_pane(window, pane, "Down")
					else
						window:perform_action({ ActivatePaneDirection = "Down" }, pane)
						if KeymapUtil.is_zoomed(pane) then
							window:perform_action({ SetPaneZoomState = not is_zoomed }, pane)
						end
					end
				else
					if KeymapUtil.is_in_yazi(pane) then
						window:perform_action({ ActivatePaneDirection = "Right" }, pane)
					end
					window:perform_action({ ActivatePaneDirection = "Up" }, pane)
					window:perform_action({ SetPaneZoomState = true }, pane)
				end
			end
		end),
	},
}
