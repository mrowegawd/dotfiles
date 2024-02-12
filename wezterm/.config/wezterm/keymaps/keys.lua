local MapUtil = require("keymaps.utils")
local Constant = require("constant")

local Util = require("utils")

local wezterm = require("wezterm")
local act = wezterm.action

local function spawn_toggle_pane(window, pane)
	window:perform_action(
		act.SplitPane({
			direction = "Right", -- Down
			-- command = { args = { "top" } },
			size = { Percent = 25 },
		}),
		pane
	)
	Constant.update_ctrl_f_panes({
		pane_id = tonumber(pane:tab():active_pane():pane_id()),
		tab_id = pane:window():active_tab():tab_id(),
		run_as = "toggle_term",
	})
end

local function spawn_nnn(window, pane)
	window:perform_action(
		act.SplitPane({
			direction = "Left",
			command = {
				args = {
					os.getenv("SHELL"), -- tanpa add `SHELL` ini, $PATH nya hilang. Check https://github.com/wez/wezterm/issues/3950
					"-c",
					"nnn",
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

local function is_in_nvim(pane)
	return string.match(pane:get_foreground_process_name(), "nvim")
end

local function is_in_nnn(pane)
	return string.match(pane:get_foreground_process_name(), "nnn")
end

return {
	-- ╭──────╮
	-- │ PANE │
	-- ╰──────╯
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

	MapUtil.split_nav("move", "ALT", "h", "Left"),
	MapUtil.split_nav("move", "ALT", "j", "Down"),
	MapUtil.split_nav("move", "ALT", "k", "Up"),
	MapUtil.split_nav("move", "ALT", "l", "Right"),

	MapUtil.split_nav("resize", "ALT", "L", "Right"),
	MapUtil.split_nav("resize", "ALT", "H", "Left"),
	MapUtil.split_nav("resize", "ALT", "K", "Up"),
	MapUtil.split_nav("resize", "ALT", "J", "Down"),

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

	-- ╭─────╮
	-- │ TAB │
	-- ╰─────╯
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

	-- ╭──────────╮
	-- │ TERMINAL │
	-- ╰──────────╯
	{
		mods = "ALT",
		key = "f",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "f", mods = "ALT" } }, pane)
			else
				local panes = pane:tab():panes_with_info()

				-- local current_tab_id = pane:window():active_tab():tab_id()
				-- wezterm.log_info("current tab " .. tostring(current_tab_id))

				-- for _, p in ipairs(panes) do
				-- 	if #Constant.get_tbl_ctrl_f_panes() > 0 then
				-- 		for _, pane_ctrl_f in pairs(Constant.get_tbl_ctrl_f_panes()) do
				-- 			if p.pane:pane_id() == pane_ctrl_f.pane_id then
				-- 				if current_tab_id == pane_ctrl_f.tab_id then
				-- 					wezterm.log_info("delete window")
				-- 					Util.removebyKey(Constant.get_tbl_ctrl_f_panes(), p.pane:pane_id())
				-- 					Constant.config.ctrl_f_pane_actived = false
				-- 				end
				-- 			end
				-- 		end
				-- 		-- else
				-- 		-- 	if #Constant.get_tbl_ctrl_f_panes() == 0 then
				-- 		-- 		Constant.config.ctrl_f_pane_actived = true
				-- 		-- 	end
				-- 	end
				-- end

				if #panes == 1 then
					local pane_nnn = pane:tab():get_pane_direction("Left")
					if pane_nnn then
						return
					end
					local pane_id = pane:tab():get_pane_direction("Right")
					if pane_id then
						window:perform_action({ ActivatePaneDirection = "Right" }, pane)
					else
						spawn_toggle_pane(window, pane)
					end
				elseif #panes == 2 then
					if is_in_nvim(pane) then
						local pane_id = pane:tab():get_pane_direction("Right")
						if not pane_id then
							spawn_toggle_pane(window, pane)
							return
						end

						window:perform_action({ ActivatePaneDirection = "Right" }, pane)
						return
					elseif is_in_nnn(pane) then
						window:perform_action({ ActivatePaneDirection = "Right" }, pane)
					else
						window:perform_action({ ActivatePaneDirection = "Left" }, pane)
					end
				elseif #panes == 3 then
					if is_in_nvim(pane) then
						window:perform_action({ ActivatePaneDirection = "Right" }, pane)
					elseif is_in_nnn(pane) then
						window:perform_action({ ActivatePaneDirection = "Right" }, pane)
					else
						window:perform_action({ ActivatePaneDirection = "Left" }, pane)
					end
				end

				-- window:toast_notification("wezterm", tostring(pane:tab():get_title()), nil, 4000)
				wezterm.log_info(Constant.get_tbl_ctrl_f_panes())

				-- window:perform_action(
				-- 	act.SplitPane({
				-- 		direction = "Left",
				-- 		command = { args = { "top" } },
				-- 		size = { Percent = 50 },
				-- 	}),
				-- 	pane
				-- )
			end
		end),
	},

	-- ╭────────╮
	-- │ REMOVE │
	-- ╰────────╯
	{
		mods = "ALT",
		key = "x",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "x", mods = "ALT" } }, pane)
			else
				window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
			end
		end),
	},
	{
		mods = "ALT",
		key = "X",
		action = wezterm.action_callback(function(window, pane)
			if Util.is_tmux(pane) then
				window:perform_action({ SendKey = { key = "X", mods = "ALT" } }, pane)
			else
				window:perform_action({ CloseCurrentTab = { confirm = true } }, pane)
			end
		end),
	},

	-- ╭──────╮
	-- │ MISC │
	-- ╰──────╯
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "Clipboard" }) },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },
	{ key = "=", mods = "CTRL", action = "IncreaseFontSize" },
	{ key = "-", mods = "CTRL", action = "DecreaseFontSize" },
	{ key = "Home", mods = "CTRL", action = "ResetFontSize" },

	{ mods = "ALT", key = "P", action = act.ActivateCommandPalette },

	{ -- enter copy mode
		key = "Enter",
		mods = "ALT|SHIFT",
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
	{ -- open pane-tree
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
					spawn_nnn(window, pane)
				elseif #panes == 2 then
					if is_in_nnn(pane) then
						window:perform_action({ ActivatePaneDirection = "Right" }, pane)
						return
					end
					if is_in_nvim(pane) then
						local pane_id = pane:tab():get_pane_direction("Left")
						if not pane_id then
							spawn_nnn(window, pane)
							return
						end

						window:perform_action({ ActivatePaneDirection = "Left" }, pane)
						return
					end
				elseif #panes == 3 then
					if is_in_nvim(pane) then
						window:perform_action({ ActivatePaneDirection = "Left" }, pane)
					elseif is_in_nnn(pane) then
						window:perform_action({ ActivatePaneDirection = "Right" }, pane)
					else
						window:perform_action({ ActivatePaneDirection = "Left" }, pane)
					end
				end

				-- local panes = pane:tab():panes_with_info()

				-- local is_pane_nnn_spawned
				-- for _, p in ipairs(panes) do
				-- 	wezterm.log_info(p)
				-- 	if p.pane:get_title() == "nnn" then
				-- 		is_pane_nnn_spawned = true
				-- 	end
				-- end

				-- window:toast_notification("wezterm", tostring(pane_nnn_spawned), nil, 4000)

				-- 	if not is_pane_nnn_spawned then
				-- 		window:perform_action(
				-- 			act.SplitPane({
				-- 				direction = "Left",
				-- 				command = {
				-- 					args = {
				-- 						os.getenv("SHELL"), -- tanpa add `SHELL` ini, $PATH nya hilang. Check https://github.com/wez/wezterm/issues/3950
				-- 						"-c",
				-- 						"nnn",
				-- 					},
				-- 				},
				-- 				size = { Percent = 15 },
				-- 			}),
				-- 			pane
				-- 		)
				-- 	else
				-- 		local pane_id = pane:tab():get_pane_direction("Right")
				-- 		if pane_id then
				-- 			window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
				-- 		end
				-- 	end
			end
		end),
	},

	-- vim - command prompt
	-- {
	-- 	mods = "CTRL",
	-- 	key = "p",
	-- 	action = act.Multiple({
	-- 		act.SendKey({ key = "\x1b" }), -- escape
	-- 		act.SendKey({ key = " " }),
	-- 		act.SendKey({ key = "f" }),
	-- 		act.SendKey({ key = "c" }),
	-- 	}),
	-- },
}
