local Util = require("utils")
local Color = require("colors")

local wezterm = require("wezterm")
local act = wezterm.action

-- Link for checking mapping keys:
-- https://wezfurlong.org/wezterm/config/keys.html

-- Example configuration for wezterm.lua:
-- https://github.com/bew/dotfiles/blob/main/gui/wezterm/wezterm.lua

-- Example wezterm lua configurations:
-- https://github.com/wez/wezterm/discussions/628

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

	local wallpapers_glob = Util.cmd_call("cat /tmp/bg-windows | xargs")
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

-- local function active_pane(tab)
-- 	for _, item in ipairs(tab:panes_with_info()) do
-- 		if item.is_active then
-- 			return item.pane
-- 		end
-- 	end
-- end

local function nav_numbers(key)
	return {
		key = key,
		mods = "ALT",
		action = wezterm.action_callback(function(window, pane)
			if is_tmux(pane) then
				window:perform_action({ SendKey = { key = key, mods = "ALT" } }, pane)
			else
				-- number pane wezterm itu dimulai dari 0, makanya di kurangin 1
				window:perform_action(act.ActivateTab(tonumber(key) - 1), pane)
			end
		end),
	}
end

-- local mods = wezterm.target_triple:find("windows") and "SHIFT|CTRL" or "SHIFT|SUPER"

-- local function strip_home_name(text)
-- 	local username = os.getenv("USER")
-- 	local clean_text = text:gsub("/home/" .. username, "~")
-- 	return clean_text
-- end

local scrollback_lines = 5000 -- default is 3500

local function edit_in_new_tab(window, pane, text)
	if not text then
		return nil
	end
	local path = os.tmpname()
	local f = io.open(path, "w+")
	if not f then
		wezterm.log_error("could not open temp file for writing")
		return
	end
	f:write(text)
	f:flush()
	f:close()
	local args = {
		"zsh",
		"-ic",
		'nvim "$0"; ' .. 'wezterm cli activate-pane --pane-id "$1"',
		path,
		tostring(pane:pane_id()),
	}
	window:perform_action(act.SpawnCommandInNewTab({ args = args }), pane)
	wezterm.sleep_ms(1000)
	os.remove(path)
end

wezterm.on("trigger-nvim-with-scrollback", function(window, pane)
	local scrollback = pane:get_lines_as_text(scrollback_lines)
	edit_in_new_tab(window, pane, scrollback)
end)

-- wezterm.on("update-right-status", function(window, pane)
-- 	local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")
--
-- 	-- Make it italic and underlined
-- 	window:set_right_status(wezterm.format({
-- 		{ Attribute = { Underline = "Single" } },
-- 		{ Attribute = { Italic = true } },
-- 		{ Text = "Hello " .. date },
-- 	}))
-- end)
wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = "[Z] "
	end

	local index = ""
	if #tabs > 1 then
		index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
	end

	return zoomed .. index .. tab.active_pane.title
end)

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	if config.use_fancy_tab_bar or not config.enable_tab_bar then
		return
	end

	local title = tab_title(tab)
	if tab.is_active then
		return {
			{ Background = { Color = Color.red_alt } },
			{ Foreground = { Color = Color.bg } },
			{ Attribute = { Intensity = "Bold" } },
			{ Text = " " .. title .. " " },
		}
	end

	local has_unseen_output = false
	for _, pane in ipairs(tab.panes) do
		if pane.has_unseen_output then
			has_unseen_output = true
			break
		end
	end

	if has_unseen_output then
		return {
			{ Background = { Color = Color.white } },
			{ Foreground = { Color = Color.black_alt } },
			{ Text = " " .. tab.active_pane.title .. " " },
		}
	end

	return title
end)

return {
	-- [1.0] alpha channel value with floating point numbers in the range 0.0
	-- (meaning completely translucent/transparent) through to 1.0 (meaning
	-- completely opaque)- Base
	-- window_background_opacity = 0.7,
	window_close_confirmation = "NeverPrompt",
	-- window_decorations = "RESIZE",
	window_decorations = "NONE",
	exit_behavior = "Close",
	cursor_blink_rate = 400,
	warn_about_missing_glyphs = false,

	-- ├┤ BAR ├───────────────────────────────────────────────────────────┤
	-- tab_bar_at_bottom = true,
	show_new_tab_button_in_tab_bar = true,
	show_tab_index_in_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	show_tabs_in_tab_bar = true,
	switch_to_last_active_tab_when_closing_tab = false,
	tab_and_split_indices_are_zero_based = false,
	tab_bar_at_bottom = false,
	tab_max_width = 25,
	use_fancy_tab_bar = false, -- disable ini membuat bar jadi polos

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
		active_titlebar_bg = Color.bg,
		inactive_titlebar_bg = Color.bg,
	},

	-- ├┤ COLORS ├────────────────────────────────────────────────────────┤
	background = {
		get_wallpaper(),
	},
	colors = {
		tab_bar = {
			background = Color.bg,
		},
	},

	-- ├┤ RULES ├─────────────────────────────────────────────────────────┤
	-- TODO: doesnt work!, Ga tau cara paakai `hyperlink_rules`
	hyperlink_rules = {
		-- Matches: a URL in parens: (URL)
		{
			regex = "\\((\\w+://\\S+)\\)",
			format = "$0",
			highlight = 1,
		},
		-- Matches: a URL in brackets: [URL]
		{
			regex = "\\[(\\w+://\\S+)\\]",
			format = "$0",
			highlight = 1,
		},
		-- Matches: a URL in curly braces: {URL}
		{
			regex = "\\{(\\w+://\\S+)\\}",
			format = "$0",
			highlight = 1,
		},
		-- Matches: a URL in angle brackets: <URL>
		{
			regex = "<(\\w+://\\S+)>",
			format = "$0",
			-- highlight = 1,
		},
	},

	-- ├┤ FONTS ├───────────────────────────────────────────────────────────┤
	font_size = 11,
	line_height = 1,
	font_shaper = "Harfbuzz",
	adjust_window_size_when_changing_font_size = false,
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
	-- disable_default_mouse_bindings = false,

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

		nav_numbers("1"), -- first window
		nav_numbers("2"),
		nav_numbers("3"),
		nav_numbers("4"),
		nav_numbers("5"),
		nav_numbers("6"),

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
						-- window:toast_notification("wezterm", "hello", nil, 4000)
						window:perform_action({ SetPaneZoomState = false }, pane)
						window:perform_action(act.SplitVertical({ domain = "CurrentPaneDomain" }), pane)
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
		{ mods = "ALT", key = "m", action = act.TogglePaneZoomState },

		{ -- capture pane
			mods = "ALT",
			key = "c",
			action = wezterm.action_callback(function(window, pane)
				if is_tmux(pane) then
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
				if is_tmux(pane) then
					window:perform_action({ SendKey = { key = "w", mods = "ALT" } }, pane)
				else
					window:perform_action(act.ShowTabNavigator, pane)
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
	},
}
