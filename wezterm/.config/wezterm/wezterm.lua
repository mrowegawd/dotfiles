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
	-- local names = { name, "FiraCode Nerd Font" }

	return wezterm.font_with_fallback({ name }, params)
end

local color_schemes = {
	["Pangkalpinang"] = {
		background = Color.bg,
		foreground = Color.fg,
		cursor_bg = Color.magenta,
		cursor_border = Color.blue,
		split = Color.separator_fg,
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

local config = wezterm.config_builder()

-- if Util.is_windows then
-- 	-- config.default_prog = { "pwsh", "-NoLogo", "-ExecutionPolicy", "RemoteSigned", "-NoProfileLoadTime" }
-- end

if wezterm.target_triple:find("windows") then
	config.launch_menu = {
		{
			label = " PowerShell V7",
			args = {
				"pwsh",
				"-NoLogo",
				"-ExecutionPolicy",
				"RemoteSigned",
				"-NoProfileLoadTime",
			},
			cwd = "~",
		},
		{ label = " PowerShell V5", args = { "powershell" }, cwd = "~" },
		{ label = "Command Prompt", args = { "cmd.exe" }, cwd = "~" },
		{ label = " Git bash", args = { "sh", "-l" }, cwd = "~" },
	}

	-- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
	config.wsl_domains = {
		{
			name = "WSL:Ubuntu",
			distribution = "Ubuntu",
			username = "mr00x",
			default_cwd = "/home/mr00x",
			default_prog = { "zsh" },
		},
		{
			name = "WSL:Alpine",
			distribution = "Alpine",
			username = "sravioli",
			default_cwd = "/home/sravioli",
		},
	}
	-- config.default_prog = { "pwsh" }
	config.font_size = 9 -- pengaturan font agar mudah dibaca
	config.window_decorations = "RESIZE"
	wezterm.on("gui-startup", function(cmd)
		local screen = wezterm.gui.screens().active
		local _, _, window = wezterm.mux.spawn_window(cmd or {})
		local gui = window:gui_window()
		local width = 0.9 * screen.width
		local height = 0.9 * screen.height
		gui:set_inner_size(width, height)
		gui:set_position((screen.width - width) / 2, (screen.height - height) / 2)
	end)
	-- wezterm.on("gui-startup", function()
	-- 	local _, _, window = wezterm.mux.spawn_window({})
	-- 	window:gui_window():maximize()
	-- end)
else
	-- config.term = "wezterm"
	config.window_decorations = "RESIZE"
	config.font_size = 11.5 -- pengaturan font agar mudah dibaca
end

-- [1.0] alpha channel value with floating point numbers in the range 0.0
-- (meaning completely translucent/transparent) through to 1.0 (meaning
-- completely opaque)- Base
-- window_background_opacity = 0.7,
config.window_close_confirmation = "NeverPrompt"
config.exit_behavior = "Close"
config.cursor_blink_rate = 400
config.warn_about_missing_glyphs = false

-- default_prog = { "zsh", "-l" },

-- ├┤ BAR ├─────────────────────────────────────────────────────────────┤
-- tab_bar_at_bottom = true,
config.show_new_tab_button_in_tab_bar = true
config.show_tab_index_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.show_tabs_in_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = false
config.tab_and_split_indices_are_zero_based = false
config.tab_bar_at_bottom = false
config.tab_max_width = 30
config.use_fancy_tab_bar = false -- disable ini membuat bar jadi polos

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- For Mac
-- set_environment_variables = {
-- 	PATH = "/Users/quantong/.cargo/bin:" .. "/opt/homebrew/bin:" .. os.getenv("PATH"),
-- },

if not wezterm.target_triple:find("windows") then
	config.set_environment_variables = {
		PATH = wezterm.home_dir .. "/.asdf/shims:" .. wezterm.home_dir .. "/.fzf/bin:" .. os.getenv("PATH"),
	}
	-- else
	-- 	config.set_environment_variables = {}
end

config.inactive_pane_hsb = {
	saturation = 0.7,
	brightness = 0.7,
}

-- ├┤ FRAME ├───────────────────────────────────────────────────────────┤
config.window_frame = {
	active_titlebar_bg = Color.bg,
	inactive_titlebar_bg = Color.bg,
}

-- ├┤ COLORS ├──────────────────────────────────────────────────────────┤
-- config.background = {
-- 	Background.get_wallpaper(),
-- },
config.color_schemes = color_schemes
config.color_scheme = "Pangkalpinang"
config.colors = {
	tab_bar = {
		background = Color.bg,
	},
}

-- ├┤ HYPERLINKS-RULES ├────────────────────────────────────────────────┤
config.hyperlink_rules = Hyperlinks

-- ├┤ FONTS ├───────────────────────────────────────────────────────────┤
config.line_height = 0.9 -- dan juga ini
-- font_shaper = "Harfbuzz",
config.harfbuzz_features = { "calt=0" }
config.adjust_window_size_when_changing_font_size = false
config.font_rules = {
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
		font = font_with_fallback("Victor Mono", { weight = "Regular" }),
	},
	{
		italic = false,
		-- intensity = "Bold",
		font = font_with_fallback("Victor Mono", {}),
	},
}

-- ├┤ MAPPINGS ├────────────────────────────────────────────────────────┤
config.disable_default_key_bindings = true
-- front_end = "OpenGL",
-- config.leader = { key = "`", mods = "CTRL" }
config.keys = Key
config.mouse_bindings = KeyMouse
config.key_tables = KeyTbl

return config
