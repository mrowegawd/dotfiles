local wezterm = require("wezterm")

-- Link for checking mapping keys:
-- https://wezfurlong.org/wezterm/config/keys.html

-- Example configuration for wezterm.lua:
-- https://github.com/bew/dotfiles/blob/main/gui/wezterm/wezterm.lua

-- Example wezterm lua configurations:
-- https://github.com/wez/wezterm/discussions/628

local myfunc = function(params)
	local handle = io.popen(params)
	local result = handle:read("*a")
	handle:close()
	return result:gsub("\n", "")
end
-- The filled in variant of the < symbol

local LEFT_ARROW = utf8.char(0xff0b3)
-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

local COL_BG = "#eceff4"
local COL_BG_ALT = "#d8dee9"
local COL_FG = "#4c566a"
local COL_FG_ALT = "#5e81ac"
local COL_ACCENT = "#88c0d0"

-- wezterm.on(
--     "format-tab-title",
--     function(tab, tabs, panes, config, hover, max_width)
--         -- edge icon
--         local edge_background = COL_BG
--         -- inactive tab
--         local background = COL_BG_ALT
--         local foreground = COL_FG

--         if tab.is_active then
--             background = COL_FG_ALT
--             foreground = COL_BG
--         elseif hover then
--             background = COL_ACCENT
--             foreground = COL_FG
--         end

--         local edge_foreground = background
--         clean_title = strip_home_name(tab.active_pane.title)

--         return {
--             { Background = { Color = edge_background } },
--             { Foreground = { Color = edge_foreground } },
--             { Text = SOLID_LEFT_ARROW },
--             { Background = { Color = background } },
--             { Foreground = { Color = foreground } },
--             { Text = clean_title },
--             { Background = { Color = edge_background } },
--             { Foreground = { Color = edge_foreground } },
--             { Text = SOLID_RIGHT_ARROW },
--         }
--     end
-- )

return {
	-- [1.0] alpha channel value with floating point numbers in the range 0.0
	-- (meaning completely translucent/transparent) through to 1.0 (meaning
	-- completely opaque)- Base
	window_background_opacity = 0.7,
	window_close_confirmation = "NeverPrompt",
	exit_behavior = "Close",
	window_padding = {
		left = 10,
		right = 10,
		top = 0,
		bottom = 2,
	},

	-- Fonts
	font = wezterm.font_with_fallback({
		-- "LiterationMono Nerd Font",
		-- "TerminessTTF Nerd Font",
		-- "SauceCodePro Nerd Font",
		-- "Iosevka Nerd Font",
		"JetBrainsMono Nerd Font",
		-- "Hack Nerd Font",
		-- "Cascadia Mono",
		-- "LastResort",
	}),
	adjust_window_size_when_changing_font_size = false,
	warn_about_missing_glyphs = false,
	-- font_antialias = "Subpixel", -- None, Greyscale, Subpixel
	-- font_hinting = "None", -- None, Vertical, VerticalSubpixel, Full
	font_size = 7.5,
	disable_default_key_bindings = true,
	disable_default_mouse_bindings = false,
	-- font_hinting = "Full",
	-- font_shaper = "Harfbuzz",
	-- allow_square_glyphs_to_overflow_width = "Always",

	-- Mappings
	-- leader = { key = "a", mods = "CTRL" },
	leader = { key = "`", mods = "CTRL" },
	keys = {
		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
		{
			key = "a",
			mods = "LEADER|CTRL",
			action = wezterm.action({ SendString = "\x01" }),
		},
		{ key = "f", mods = "LEADER", action = "QuickSelect" },
		{
			key = "l",
			mods = "LEADER",
			action = wezterm.action({
				SplitHorizontal = { domain = "CurrentPaneDomain" },
			}),
		},
		{
			key = "j",
			mods = "LEADER",
			action = wezterm.action({
				SplitVertical = { domain = "CurrentPaneDomain" },
			}),
		},
		{
			key = "n",
			mods = "LEADER",
			action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
		},
		{
			key = "c",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ CopyTo = "Clipboard" }),
		},
		{
			key = "v",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ PasteFrom = "Clipboard" }),
		},
		{ key = "N", mods = "LEADER", action = "ShowLauncher" },
		{ key = "R", mods = "LEADER", action = "ReloadConfiguration" },
		{ key = "m", mods = "LEADER", action = "TogglePaneZoomState" }, -- toggle maximize
		{ key = "j", mods = "CTRL|SHIFT", action = "IncreaseFontSize" },
		{ key = "k", mods = "CTRL|SHIFT", action = "DecreaseFontSize" },
		{ key = "Home", mods = "CTRL|SHIFT", action = "ResetFontSize" },
		{ key = "Enter", mods = "LEADER", action = "ActivateCopyMode" },
		{
			key = "h",
			mods = "ALT|CTRL",
			action = wezterm.action({ MoveTabRelative = -1 }),
		},
		{
			key = "l",
			mods = "ALT|CTRL",
			action = wezterm.action({ MoveTabRelative = 1 }),
		},
		{

			key = "h",
			mods = "ALT",
			action = wezterm.action({ ActivateTabRelative = -1 }),
		},
		{
			key = "l",
			mods = "ALT",
			action = wezterm.action({ ActivateTabRelative = 1 }),
		},
		{
			key = "q",
			mods = "LEADER",
			action = wezterm.action({ CloseCurrentPane = { confirm = true } }),
		},
		{
			key = "LeftArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivatePaneDirection = "Left" }),
		},
		{
			key = "DownArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivatePaneDirection = "Down" }),
		},
		{
			key = "UpArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivatePaneDirection = "Up" }),
		},
		{
			key = "RightArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivatePaneDirection = "Right" }),
		},
		{
			key = "1",
			mods = "LEADER",
			action = wezterm.action({ ActivateTab = 0 }),
		},
		{
			key = "2",
			mods = "LEADER",
			action = wezterm.action({ ActivateTab = 1 }),
		},
		{
			key = "3",
			mods = "LEADER",
			action = wezterm.action({ ActivateTab = 2 }),
		},
		{
			key = "4",
			mods = "LEADER",
			action = wezterm.action({ ActivateTab = 3 }),
		},
		{
			key = "5",
			mods = "LEADER",
			action = wezterm.action({ ActivateTab = 4 }),
		},
		{
			key = "6",
			mods = "LEADER",
			action = wezterm.action({ ActivateTab = 5 }),
		},
		{
			key = "7",
			mods = "LEADER",
			action = wezterm.action({ ActivateTab = 6 }),
		},
		{
			key = "8",
			mods = "LEADER",
			action = wezterm.action({ ActivateTab = 7 }),
		},
		{
			key = "9",
			mods = "LEADER",
			action = wezterm.action({ ActivateTab = 8 }),
		},
		{
			key = "K",
			mods = "LEADER",
			action = wezterm.action({ ClearScrollback = "ScrollbackOnly" }),
		},
		{
			key = "k",
			mods = "LEADER",
			action = wezterm.action({ ScrollToPrompt = 1 }),
		},
		{
			key = "j",
			mods = "LEADER",
			action = wezterm.action({ ScrollToPrompt = -1 }),
		},
		{
			key = "PageUp",
			mods = "NONE",
			action = wezterm.action({ ScrollByPage = -1 }),
		},
		{
			key = "PageDown",
			mods = "NONE",
			action = wezterm.action({ ScrollByPage = 1 }),
		},
	},
	window_frame = {
		-- The font used in the tab bar.
		-- Roboto Bold is the default; this font is bundled
		-- with wezterm.
		-- Whatever font is selected here, it will have the
		-- main font setting appended to it to pick up any
		-- fallback fonts you may have used there.
		font = wezterm.font({ family = "Roboto", weight = "Bold" }),

		-- The size of the font in the tab bar.
		-- Default to 10. on Windows but 12.0 on other systems
		font_size = 8.0,

		-- The overall background color of the tab bar when
		-- the window is focused
		active_titlebar_bg = myfunc("xrdb -query | grep -i background| cut -d':' -f2 | xargs"),

		-- The overall background color of the tab bar when
		-- the window is not focused
		inactive_titlebar_bg = myfunc("xrdb -query | grep -i background| cut -d':' -f2 | xargs"),
	},
	colors = {
		-- The default text color
		foreground = myfunc("xrdb -query | grep -i foreground| cut -d':' -f2 | xargs"),
		-- The default background color
		background = myfunc("xrdb -query | grep -i background| cut -d':' -f2 | xargs"),

		tab_bar = {
			--     -- The color of the strip that goes along the top of the window
			--     -- (does not apply when fancy tab bar is in use)
			--     background = myfunc "xrdb -query | grep -i background| cut -d':' -f2 | xargs",

			--     -- The active tab is the one that has focus in the window
			active_tab = {
				--         -- The color of the background area for the tab
				-- bg_color = myfunc "xrdb -query | grep -i | cut -d':' -f2 | xargs",
				bg_color = "red",
				--         -- The color of the text for the tab
				fg_color = "black",

				--         -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
				--         -- label shown for this tab.
				--         -- The default is "Normal"
				--         intensity = "Normal",

				--         -- Specify whether you want "None", "Single" or "Double" underline for
				--         -- label shown for this tab.
				--         -- The default is "None"
				--         underline = "None",

				--         -- Specify whether you want the text to be italic (true) or not (false)
				--         -- for this tab.  The default is false.
				--         italic = false,

				--         -- Specify whether you want the text to be rendered with strikethrough (true)
				--         -- or not for this tab.  The default is false.
				--         strikethrough = false,
				--     },

				--     -- Inactive tabs are the tabs that do not have focus
				--     inactive_tab = {
				--         bg_color = "#1b1032",
				--         fg_color = "#808080",

				--         -- The same options that were listed under the `active_tab` section above
				--         -- can also be used for `inactive_tab`.
				--     },

				--     -- You can configure some alternate styling when the mouse pointer
				--     -- moves over inactive tabs
				--     inactive_tab_hover = {
				--         bg_color = "#3b3052",
				--         fg_color = "#909090",
				--         italic = true,

				--         -- The same options that were listed under the `active_tab` section above
				--         -- can also be used for `inactive_tab_hover`.
				--     },

				--     -- The new tab button that let you create new tabs
				--     new_tab = {
				--         bg_color = "#1b1032",
				--         fg_color = "#808080",

				--         -- The same options that were listed under the `active_tab` section above
				--         -- can also be used for `new_tab`.
				--     },

				--     -- You can configure some alternate styling when the mouse pointer
				--     -- moves over the new tab button
				--     new_tab_hover = {
				--         bg_color = "#3b3052",
				--         fg_color = "#909090",
				--         italic = true,

				--         -- The same options that were listed under the `active_tab` section above
				--         -- can also be used for `new_tab_hover`.
			},
		},
	},
}
