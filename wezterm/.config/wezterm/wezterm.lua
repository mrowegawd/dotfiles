local Color = require("colors")
-- local Background = require("background")
local Hyperlinks = require("hyperlinks")

local Key = require("keymaps.keys")
local KeyTbl = require("keymaps.keys-table")
local KeyMouse = require("keymaps.mouse")

local wezterm = require("wezterm")

require("event")
require("statusline")

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

local color_schemes = {
	["Pangkalpinang"] = {
		background = Color.bg,
		foreground = Color.fg,
		cursor_bg = Color.magenta,
		cursor_border = Color.blue,
		split = Color.black_alt,
		ansi = {
			Color.black,
			Color.red,
			Color.green,
			Color.yellow,
			Color.blue,
			Color.cyan,
			Color.magenta,
			Color.white,
		},
		brights = {
			Color.black_alt,
			Color.red_alt,
			Color.green_alt,
			Color.yellow_alt,
			Color.blue_alt,
			Color.cyan_alt,
			Color.magenta_alt,
			Color.white_alt,
		},
	},
}

return {
	-- [1.0] alpha channel value with floating point numbers in the range 0.0
	-- (meaning completely translucent/transparent) through to 1.0 (meaning
	-- completely opaque)- Base
	-- window_background_opacity = 0.7,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "NONE", -- "RESIZE",
	exit_behavior = "Close",
	cursor_blink_rate = 400,
	warn_about_missing_glyphs = false,

	-- default_prog = { "zsh", "-l" },

	-- ├┤ BAR ├─────────────────────────────────────────────────────────────┤
	-- tab_bar_at_bottom = true,
	show_new_tab_button_in_tab_bar = true,
	show_tab_index_in_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	show_tabs_in_tab_bar = true,
	switch_to_last_active_tab_when_closing_tab = false,
	tab_and_split_indices_are_zero_based = false,
	tab_bar_at_bottom = false,
	tab_max_width = 30,
	use_fancy_tab_bar = false, -- disable ini membuat bar jadi polos

	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},

	-- For Mac
	-- set_environment_variables = {
	-- 	PATH = "/Users/quantong/.cargo/bin:" .. "/opt/homebrew/bin:" .. os.getenv("PATH"),
	-- },

	set_environment_variables = {
		PATH = wezterm.home_dir .. "/.asdf/shims:" .. wezterm.home_dir .. "/.fzf/bin:" .. os.getenv("PATH"),
	},

	inactive_pane_hsb = {
		saturation = 1,
		brightness = 1,
	},

	-- ├┤ FRAME ├───────────────────────────────────────────────────────────┤
	window_frame = {
		active_titlebar_bg = Color.bg,
		inactive_titlebar_bg = Color.bg,
	},

	-- ├┤ COLORS ├──────────────────────────────────────────────────────────┤
	-- background = {
	-- 	Background.get_wallpaper(),
	-- },
	color_schemes = color_schemes,
	color_scheme = "Pangkalpinang",
	colors = {
		tab_bar = {
			background = Color.bg,
		},
	},

	-- ├┤ HYPERLINKS-RULES ├────────────────────────────────────────────────┤
	hyperlink_rules = Hyperlinks,

	-- ├┤ FONTS ├───────────────────────────────────────────────────────────┤
	font_size = 10.9, -- pengaturan font agar mudah dibaca
	line_height = 0.9, -- dan juga ini
	-- font_shaper = "Harfbuzz",
	harfbuzz_features = { "calt=0" },
	adjust_window_size_when_changing_font_size = false,
	font_rules = {
		{
			italic = false,
			intensity = "Normal",
			font = font_with_fallback("SF Mono", {}),
		},
		{
			italic = false,
			-- intensity = "Bold",
			font = font_with_fallback("SF Mono", { weight = "Bold" }),
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
	-- front_end = "OpenGL",
	leader = { key = "`", mods = "CTRL" },
	keys = Key,
	mouse_bindings = KeyMouse,
	key_tables = KeyTbl,
}
