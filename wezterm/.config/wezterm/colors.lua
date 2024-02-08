local Util = require("utils")
local M = {}

M = {
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
}

return M
