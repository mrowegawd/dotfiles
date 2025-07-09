# vim: foldmethod=marker foldlevel=0

local KeymapUtil = require("keymaps.utils")
local Constant = require("constant")

local wezterm = require("wezterm")
local act = wezterm.action

local mod_key = wezterm.target_triple:find("windows") and "SHIFT|CTRL" or "ALT"

-- Load the plugin
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

return {
  -- General --------------------------------------------------------------- {{{
  --
	{ -- enter copy mode
		key = "V",
		mods = "LEADER",
		action = act.Multiple({
			act.CopyMode("ClearSelectionMode"),
			act.ActivateCopyMode,
		}),
	},
	-- { key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay }, -- show debug relay
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "Clipboard" }) },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },
	{ key = "=", mods = "CTRL", action = "IncreaseFontSize" },
	{ key = "-", mods = "CTRL", action = "DecreaseFontSize" },
	{ key = "0", mods = "CTRL", action = "ResetFontSize" },
	{ key = "P", mods = mod_key, action = act.ActivateCommandPalette },
  --
  -- }}}
	-- Session --------------------------------------------------------------- {{{
  --
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
  --
  -- }}}
	-- Pane ------------------------------------------------------------------ {{{
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
	-- { key = "L", mods = "LEADER", action = "ShowLauncher" },
	-- { key = "v", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	-- { key = "R", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Next" }) },
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
	{ -- alternate session
		key = "B",
		mods = mod_key,
		action = wezterm.action_callback(function(window, pane)
			window:perform_action({ SendKey = { key = "b", mods = mod_key } }, pane)
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
				KeymapUtil.spawn_toggle_pane(window, pane)
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
				KeymapUtil.spawn_toggle_pane(window, pane, "Down")
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

	-- show pane ids (sama sepert tmux <bind-Q>)
	{ key = "Q", mods = "LEADER", action = wezterm.action.PaneSelect({ show_pane_ids = true }) },
	{ -- close the pane
		key = "q",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
		end),
	},
	{ -- shortcut mapping `alt-x` to close the pane
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
	{ -- close the file manager pane
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

	-- { -- Swap pane to the left
	-- 	key = "H",
	-- 	mods = "LEADER",
	-- 	action = wezterm.action({
	-- 		SplitHorizontal = { domain = "CurrentPaneDomain" },
	-- 	}),
	-- },
	-- { -- Swap pane to the right
	-- 	key = "R",
	-- 	jmods = "ALT",
	-- 	action = wezterm.action_callback(function(window, pane)
	-- 		if KeymapUtil.is_in_tmux(pane) then
	-- 			window:perform_action({ SendKey = { key = "L", mods = "LEADER" } }, pane)
	-- 		else
	-- 			-- Swap the current pane with the one on the right
	-- 			window:perform_action(act.RotatePanes("Clockwise"), pane)
	-- 		end
	-- 	end),
	-- },

	{ -- pane zoom
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
	{ -- reset pane size
		key = "w",
		mods = mod_key,
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "w", mods = mod_key } }, pane)
			else
				window:toast_notification("wezterm", "Reset pane size: this feature is not implemented yet", nil, 4000)
				-- window:perform_action(act.ShowTabNavigator, pane)
				-- local panes = pane:tab():panes_with_info()
				-- panes[#panes].pane:activate()
				-- panes[#panes].pane:split({ direction = "Bottom" })
				-- for i = 1, #panes + 1 do
				-- 	local p = pane:tab():panes_with_info()[i]
				-- 	win:perform_action({ AdjustPaneSize = { "Up", 3 } }, p.pane)
				-- 	p.pane:send_text(string.format("%d:%d ", i, p.height))
				-- end
				-- panes[1].pane:activate()
			end
		end),
	},

	-- }}}
	-- Window ---------------------------------------------------------------- {{{ 
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
  -- }}} 
	-- Misc ------------------------------------------------------------------ {{{
  -- 
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
				if KeymapUtil.is_right_pane_exists(pane) then
					window:perform_action({ ActivatePaneDirection = "Right" }, pane)
					return
				end

				KeymapUtil.spawn_file_manager(window, pane, 22, "yazi")
			end
		end),
	},
	{ -- open lazydocker
		key = "d",
		mods = mod_key,
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
					"lazydocker",
				})
			end
		end),
	},
	{ -- open lazygit
		key = "g",
		mods = mod_key,
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
		key = "o",
		mods = mod_key,
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
		key = "A",
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
	{ -- open terminal <a-f>
		mods = mod_key,
		key = "f",
		action = wezterm.action_callback(function(window, pane)
			if KeymapUtil.is_in_tmux(pane) then
				window:perform_action({ SendKey = { key = "f", mods = mod_key } }, pane)
			else
				local session = window:active_workspace()

				if KeymapUtil.is_in_nvim(pane) then
					local workspaces = Constant.get_main_workspaces()
					local pane_id = pane:tab():active_pane():pane_id()
					local window_id = window:window_id()

					local main_workspace = workspaces[session]
					if main_workspace == nil then
						-- Save the main workspace configuration before moving the cursor down
						local opts = {
							[session] = {
								{
									pane_id = pane_id,
									window_id = window_id,
									session = session,
									cwd = "",
								},
							},
						}
						Constant.set_main_workspaces(opts)
					end

					local pane_down_id = pane:tab():get_pane_direction("Down")
					if pane_down_id == nil then
						KeymapUtil.spawn_toggle_pane(window, pane, "Down")
					end

					local panes = pane:tab():panes_with_info()
					local is_zoomed = false
					for _, p in ipairs(panes) do
						if p.is_zoomed then
							is_zoomed = true
						end
					end

					if is_zoomed then
						-- window:perform_action({ SetPaneZoomState = not is_zoomed }, pane)
						window:perform_action({ ActivatePaneDirection = "Down" }, pane)

						-- Set size pane
						local dim = pane:get_dimensions()
						local desired_height = 665
						local adjust_pane_direction = "Up"
						local add_size = 0
						if dim.pixel_height < desired_height then
							local lines_to_add = 10
							add_size = lines_to_add
							adjust_pane_direction = "Down"
						elseif dim.pixel_height > desired_height then
							local lines_to_remove = 5
							add_size = lines_to_remove
							adjust_pane_direction = "Up"
						end
						if add_size > 0 then
							window:perform_action(
								wezterm.action.AdjustPaneSize({ adjust_pane_direction, add_size }),
								pane
							)
						end
					else
						-- window:toast_notification("wezterm", "horee bro", nil, 4000)
						window:perform_action({ ActivatePaneDirection = "Down" }, pane)
						-- window:toast_notification("wezterm", "tolog", nil, 4000)
						-- window:perform_action({ SetPaneZoomState = true }, pane)
						-- end

						-- window:toast_notification("wezterm", "its open", nil, 4000)
					end
					-- session = window:active_workspace()

					-- window:toast_notification("wezterm", tostring(pane_main), nil, 4000)

					-- window:toast_notification("wezterm", tostring(), nil, 4000)

					-- local pane_down = pane:tab():get_pane_direction("Down")
					-- if pane_down == nil then
					-- 	KeymapUtil.spawn_toggle_pane(window, pane, "Down")
					-- else
					-- 	wezterm.log_info(current_main)
					--
					-- 	--
					-- 	local tab = window:active_tab()
					-- 	for _, p in ipairs(tab:panes()) do
					-- 		if p:pane_id() == current_main.pane_id then
					-- 			window:perform_action({ ActivatePaneDirection = "Down" }, pane)
					-- 			return
					-- 		else
					-- 			window:perform_action(wezterm.action({ ActivatePaneByIndex = current_main.pane_id }), p)
					-- 			return
					-- 		end
					-- 	end
					--
					-- 	-- window:perform_action(wezterm.action({ ActivatePane = current_main.pane_id }), pane)
					-- 	-- if KeymapUtil.is_pane_zoomed(pane) then
					-- 	-- 	window:perform_action({ SetPaneZoomState = not is_zoomed }, pane)
					-- 	-- end
					-- end
				else
					-- local workspaces = Constant.get_main_workspaces()
					-- -- wezterm.log_info(workspaces[session])
					-- local current_main = workspaces[session][1]
					--
					-- window:toast_notification("wezterm", "horee bro", nil, 4000)
					--
					-- -- TODO: sekarang workspaces main sudah ada, tapi cara menyematkan
					-- -- data id ke wezterm belum ngerti di wezterm..
					-- local tab = window:active_tab()
					-- for _, p in ipairs(tab:panes()) do
					-- 	if p:pane_id() == current_main.pane_id then
					-- 		window:toast_notification("wezterm", tostring(current_main.pane_id), nil, 4000)
					-- 		-- window:perform_action({ ActivatePaneDirection = "Down" }, pane)
					-- 		window:perform_action(wezterm.action({ ActivatePaneByIndex = current_main.pane_id }), p)
					-- 		-- window:perform_action(wezterm.action({ ActivatePane = p }), pane)
					-- 		return
					-- 	end
					-- end
					if KeymapUtil.is_in_yazi(pane) then
						window:perform_action({ ActivatePaneDirection = "Right" }, pane)
					end
					window:perform_action({ ActivatePaneDirection = "Up" }, pane)
					window:perform_action({ SetPaneZoomState = true }, pane)
				end
			end
		end),
	},
  --
  -- }}}
}
