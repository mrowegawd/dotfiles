local MapUtil = require("keymaps.utils")
local Constant = require("constant")

local Util = require("utils")

local wezterm = require("wezterm")
local act = wezterm.action

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
				local set_zoom = true

				Constant.config.set_zoom = false
				Constant.config.ctrl_f_pane_actived = false
				for _, p in ipairs(panes) do
					-- wezterm.log_info(p)
					if p.is_zoomed then
						Constant.config.set_zoom = true
					end
					if p.pane:pane_id() == Constant.config.ctrl_f_pane_id then
						Constant.config.ctrl_f_pane_actived = true
					end
				end

				-- window:toast_notification("wezterm", tostring(Constant.config.set_zoom), nil, 4000)

				if Constant.config.ctrl_f_pane_id == 0 or not Constant.config.ctrl_f_pane_actived then
					window:perform_action(
						act.SplitPane({
							direction = "Right", -- Down
							-- command = { args = { "top" } },
							size = { Percent = 30 },
						}),
						pane
					)
					Constant.config.ctrl_f_pane_id = pane:tab():active_pane():pane_id()

					set_zoom = false
				end

				local pane_id = pane:tab():get_pane_direction("Right")
				if pane_id then
					window:perform_action({ ActivatePaneDirection = "Right" }, pane)
				end

				if not Constant.config.set_zoom and set_zoom then
					set_zoom = false

					local current_cursor = pane:tab():active_pane():pane_id()

					window:perform_action({ ActivatePaneDirection = "Left" }, pane)

					if current_cursor == Constant.config.ctrl_f_pane_id then
						window:perform_action({ SetPaneZoomState = true }, pane)
					end
				else
					set_zoom = true
					window:perform_action({ ActivatePaneDirection = "Right" }, pane)
				end

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

				local is_pane_nnn_spawned
				for _, p in ipairs(panes) do
					wezterm.log_info(p)
					if p.pane:get_title() == "nnn" then
						is_pane_nnn_spawned = true
					end
				end

				-- window:toast_notification("wezterm", tostring(pane_nnn_spawned), nil, 4000)

				if not is_pane_nnn_spawned then
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
				else
					local pane_id = pane:tab():get_pane_direction("Right")
					if pane_id then
						window:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
					end
				end
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
