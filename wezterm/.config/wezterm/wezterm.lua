local wezterm = require("wezterm")

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

-- local function get_random_entry(tbl)
-- 	local keys = {}
-- 	for key, _ in ipairs(tbl) do
-- 		table.insert(keys, key)
-- 	end
-- 	local randomKey = keys[math.random(1, #keys)]
-- 	return tbl[randomKey]
-- end
--
-- local function get_wallpaper()
-- 	local wallpapers = {}
-- 	local wallpapers_glob = os.getenv("HOME") .. "/Downloads/wezterm-walli3/**"
--
-- 	for _, v in ipairs(wezterm.glob(wallpapers_glob)) do
-- 		table.insert(wallpapers, v)
-- 	end
-- 	return {
-- 		source = { File = { path = get_random_entry(wallpapers) } },
--
-- 		-- height = "Contain",
-- 		-- width = "Contain",
--
-- 		repeat_y = "Repeat",
-- 		repeat_x = "NoRepeat",
-- 		-- repeat_x = "Repeat",
--
-- 		width = "100%",
-- 		hsb = { brightness = 0.05 },
-- 		opacity = 1,
-- 	}
-- end

return {
	-- [1.0] alpha channel value with floating point numbers in the range 0.0
	-- (meaning completely translucent/transparent) through to 1.0 (meaning
	-- completely opaque)- Base
	-- window_background_opacity = 0.7,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	exit_behavior = "Close",
	window_padding = {
		left = 10,
		right = 10,
		top = 0,
		bottom = 2,
	},

	--  ┌╌╌╌╌╌╌╌┐
	--  ╎ Fonts ╎
	--  └╌╌╌╌╌╌╌┘
	font_size = 12,
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
			italic = true,
			-- intensity = "Normal",
			font = font_with_fallback("JetBrains Mono", { weight = "Regular" }),
		},
		{
			italic = true,
			intensity = "Bold",
			font = font_with_fallback("VictorMono NFP SemiBold Obl", {}),
		},
	},

	hide_tab_bar_if_only_one_tab = true,
	disable_default_key_bindings = true,
	disable_default_mouse_bindings = false,
	cursor_blink_rate = 0,

	--  ┌╌╌╌╌╌╌╌╌╌╌┐
	--  ╎ Mappings ╎
	--  └╌╌╌╌╌╌╌╌╌╌┘
	leader = { key = "`", mods = "CTRL" },
	keys = {
		{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "Clipboard" }) },
		{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },
		{ key = "=", mods = "CTRL", action = "IncreaseFontSize" },
		{ key = "-", mods = "CTRL", action = "DecreaseFontSize" },
		{ key = "Home", mods = "CTRL", action = "ResetFontSize" },
	},

	--  ┌╌╌╌╌╌╌╌┐
	--  ╎ Frame ╎
	--  └╌╌╌╌╌╌╌┘
	window_frame = {
		active_titlebar_bg = cmd_call("xrdb -query | grep -i background| cut -d':' -f2 | xargs"),
		inactive_titlebar_bg = cmd_call("xrdb -query | grep -i background| cut -d':' -f2 | xargs"),
	},
	-- background = {
	-- 	get_wallpaper(),
	-- },
	colors = {
		foreground = cmd_call("xrdb -query | grep -i foreground| cut -d':' -f2 | xargs"),
		background = cmd_call("xrdb -query | grep -i background| cut -d':' -f2 | xargs"),
		tab_bar = {
			active_tab = {
				bg_color = "red",
				fg_color = "black",
			},
		},
	},
}
