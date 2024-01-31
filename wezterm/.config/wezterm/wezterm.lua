local wezterm = require("wezterm")

local act = wezterm.action

-- Link for checking mapping keys:
-- https://wezfurlong.org/wezterm/config/keys.html

-- Example configuration for wezterm.lua:
-- https://github.com/bew/dotfiles/blob/main/gui/wezterm/wezterm.lua

-- Example wezterm lua configurations:
-- https://github.com/wez/wezterm/discussions/628

local cmd_call = function(params)
	local handle = io.popen(params)
	if handle == nil then
		return
	end
	local result = handle:read("*a")
	handle:close()
	return result:gsub("\n", "")
end

local function font_with_fallback(name, params)
	local names = { name, "FiraCode Nerd Font" }
	return wezterm.font_with_fallback(names, params)
end

local function get_random_entry(tbl)
	if tbl ~= "table" then
		return tbl
	end

	local keys = {}
	for key, _ in ipairs(tbl) do
		table.insert(keys, key)
	end
	local randomKey = keys[math.random(1, #keys)]
	return tbl[randomKey]
end

local function get_wallpaper()
	-- local wallpapers = {}
	-- local wallpapers_glob = os.getenv("HOME") .. "/Downloads/wezterm-walli3/**"
	-- for _, v in ipairs(wezterm.glob(wallpapers_glob)) do
	-- table.insert(wallpapers, wallpapers)
	-- end

	local wallpapers_glob = cmd_call("cat /tmp/bg-windows | xargs")
	return {
		source = { File = { path = get_random_entry(wallpapers_glob) } },
		height = "Cover",
		width = "Cover",
		horizontal_align = "Center",
		repeat_x = "Repeat",
		repeat_y = "Repeat",
		opacity = 1,
		hsb = { brightness = 0.030 },
	}
end

local function is_nvim(pane)
	return pane:get_user_vars().IS_NVIM == "true" or pane:get_foreground_process_name():find("n?vim")
end

-- TAKEN FROM: https://wezfurlong.org/wezterm/recipes/passing-data.html#user-vars
-- check file: aliases.basrc

local function is_tmux(pane)
	local isTmux = pane:get_user_vars().PROG

	if isTmux and isTmux == "tmux" or isTmux == "tm" then
		return true
	end

	return false
end

local function split_nav(resize_or_move, mods, key, dir)
	local event = "SplitNav_" .. resize_or_move .. "_" .. dir

	wezterm.on(event, function(win, pane)
		local isTmux = pane:get_user_vars().PROG

		if isTmux and isTmux == "tmux" or isTmux == "tm" then
			-- pass the keys through to vim/nvim
			-- win:toast_notification("wezterm", mods .. " keys " .. key, nil, 4000)
			win:perform_action({ SendKey = { key = key, mods = mods } }, pane)
		else
			if is_nvim(pane) then
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

-- local mods = wezterm.target_triple:find("windows") and "SHIFT|CTRL" or "SHIFT|SUPER"

return {
	-- [1.0] alpha channel value with floating point numbers in the range 0.0
	-- (meaning completely translucent/transparent) through to 1.0 (meaning
	-- completely opaque)- Base
	-- window_background_opacity = 0.7,
	window_close_confirmation = "NeverPrompt",
	-- window_decorations = "RESIZE",
	window_decorations = "NONE",
	exit_behavior = "Close",
	hide_tab_bar_if_only_one_tab = true,
	cursor_blink_rate = 400,
	adjust_window_size_when_changing_font_size = false,

	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	-- inactive_pane_hsb = {
	-- 	saturation = 0.5,
	-- 	brightness = 0.4,
	-- },

	-- ├┤ FRAME ├───────────────────────────────────────────────────────────┤
	window_frame = {
		active_titlebar_bg = cmd_call("xrdb -query | grep -i background| cut -d':' -f2 | xargs"),
		inactive_titlebar_bg = cmd_call("xrdb -query | grep -i background| cut -d':' -f2 | xargs"),
	},
	background = {
		get_wallpaper(),
	},
	-- colors = {
	-- 	foreground = cmd_call("xrdb -query | grep -i foreground| cut -d':' -f2 | xargs"),
	-- 	background = cmd_call("xrdb -query | grep -i background| cut -d':' -f2 | xargs"),
	-- 	tab_bar = {
	-- 		active_tab = {
	-- 			bg_color = "red",
	-- 			fg_color = "black",
	-- 		},
	-- 	},
	-- },

	-- ├┤ FONTS ├───────────────────────────────────────────────────────────┤
	font_size = 11.5,
	line_height = 1,
	font_rules = {
		{
			italic = false,
			intensity = "Normal",
			font = font_with_fallback("JetBrains Mono", {}),
		},
		{
			italic = false,
			-- intensity = "Bold",
			font = font_with_fallback("JetBrains Mono", { weight = "Bold" }),
		},
		{
			italic = false,
			-- intensity = "Normal",
			font = font_with_fallback("JetBrains Mono", { weight = "Regular" }),
		},
		{
			italic = true,
			intensity = "Bold",
			font = font_with_fallback("JetBrains Mono", {}),
		},
	},

	-- ├┤ MAPPINGS ├────────────────────────────────────────────────────────┤
	disable_default_key_bindings = true,
	disable_default_mouse_bindings = false,

	leader = { key = "`", mods = "CTRL" },
	keys = {
		-- ╭──────╮
		-- │ PANE │
		-- ╰──────╯
		{
			mods = "ALT",
			key = "Enter",
			action = wezterm.action_callback(function(window, pane)
				if is_tmux(pane) then
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

		split_nav("move", "ALT", "h", "Left"),
		split_nav("move", "ALT", "j", "Down"),
		split_nav("move", "ALT", "k", "Up"),
		split_nav("move", "ALT", "l", "Right"),

		split_nav("resize", "ALT", "L", "Right"),
		split_nav("resize", "ALT", "H", "Left"),
		split_nav("resize", "ALT", "K", "Up"),
		split_nav("resize", "ALT", "J", "Down"),

		-- ╭─────╮
		-- │ TAB │
		-- ╰─────╯
		-- { key = "N", mods = "ALT", action = act({ SpawnTab = "CurrentPaneDomain" }) },
		{
			mods = "ALT",
			key = "N",
			action = wezterm.action_callback(function(window, pane)
				if is_tmux(pane) then
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
				if is_tmux(pane) then
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
				if is_tmux(pane) then
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
				if is_tmux(pane) then
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
				if is_tmux(pane) then
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
				if is_tmux(pane) then
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
				if is_tmux(pane) then
					window:perform_action({ SendKey = { key = "f", mods = "ALT" } }, pane)
				else
					local panes = pane:tab():panes_with_info()

					local is_zoomed = false
					for _, p in ipairs(panes) do
						if p.is_zoomed then
							is_zoomed = true
						end
					end

					if not is_zoomed then
						window:perform_action(act.SplitVertical({ domain = "CurrentPaneDomain" }), pane)
					else
						window:perform_action({ SetPaneZoomState = is_zoomed }, pane)
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
				if is_tmux(pane) then
					window:perform_action({ SendKey = { key = "x", mods = "ALT" } }, pane)
				else
					window:perform_action({ CloseCurrentTab = { confirm = true } }, pane)
				end
			end),
		},
		{
			mods = "ALT",
			key = "X",
			action = wezterm.action_callback(function(window, pane)
				if is_tmux(pane) then
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
	},
}
