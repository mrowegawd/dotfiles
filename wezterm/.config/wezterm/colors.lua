local Util = require("utils")
local wezterm = require("wezterm")

-- if not string.find(wezterm.target_triple, "darwins") then --> mac

if not string.find(wezterm.target_triple, "windows") then
	return {
		fg = Util.cmd_call("xrdb -query | grep -i foreground| cut -d':' -f2 | xargs"),
		bg = Util.cmd_call("xrdb -query | grep -i background| cut -d':' -f2 | xargs"),

		black = Util.cmd_call("xrdb -query | grep -i .color0| cut -d':' -f2 | head -1 | xargs"),
		black_alt = Util.cmd_call("xrdb -query | grep -i .color8| cut -d':' -f2 | head -1 | xargs"),
		red = Util.cmd_call("xrdb -query | grep -i .color1| cut -d':' -f2 | head -1 | xargs"),
		red_alt = Util.cmd_call("xrdb -query | grep -i .color9| cut -d':' -f2 | head -1 | xargs"),
		green = Util.cmd_call("xrdb -query | grep -i .color2| cut -d':' -f2 | head -1 | xargs"),
		green_alt = Util.cmd_call("xrdb -query | grep -i .color10| cut -d':' -f2 | head -1 | xargs"),
		yellow = Util.cmd_call("xrdb -query | grep -i .color3| cut -d':' -f2 | head -1 | xargs"),
		yellow_alt = Util.cmd_call("xrdb -query | grep -i .color11| cut -d':' -f2 | head -1 | xargs"),
		blue = Util.cmd_call("xrdb -query | grep -i .color4| cut -d':' -f2 | head -1 | xargs"),
		blue_alt = Util.cmd_call("xrdb -query | grep -i .color12| cut -d':' -f2 | head -1 | xargs"),
		magenta = Util.cmd_call("xrdb -query | grep -i .color5| cut -d':' -f2 | head -1 | xargs"),
		magenta_alt = Util.cmd_call("xrdb -query | grep -i .color13| cut -d':' -f2 | head -1 | xargs"),
		cyan = Util.cmd_call("xrdb -query | grep -i .color6| cut -d':' -f2 | head -1 | xargs"),
		cyan_alt = Util.cmd_call("xrdb -query | grep -i .color14| cut -d':' -f2 | head -1 | xargs"),
		white = Util.cmd_call("xrdb -query | grep -i .color7| cut -d':' -f2 | head -1 | xargs"),
		white_alt = Util.cmd_call("xrdb -query | grep -i .color15| cut -d':' -f2 | head -1 | xargs"),
		-- white_alt = Util.cmd_call("xrdb -query | grep -i .color15| cut -d':' -f2 | head -1 | xargs"),
	}
else
	return {
		fg = "#dcd7ba",
		bg = "#1f1f28",

		black = "#090618",
		black_alt = "#727169",
		red = "#c34043",
		red_alt = "#e82424",
		green = "#76946a",
		green_alt = "#98bb6c",
		yellow = "#c0a36e",
		yellow_alt = "#e6c384",
		blue = "#7e9cd8",
		blue_alt = "7fb4ca",
		magenta = "#957fb8",
		magenta_alt = "#938aa9",
		cyan = "#6a9589",
		cyan_alt = "#7aa89f",
		white = "#c8c093",
		white_alt = "#dcd7ba",
	}
end
