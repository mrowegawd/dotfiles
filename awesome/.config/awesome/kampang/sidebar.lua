local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local utils = require("utils")

local bar = {}

local clock = wibox.widget({
    align = 'center',
    -- valign = 'center',
    font = 'TTCommons DemiBold 70',
    widget = wibox.widget.textclock('%H %M'),
})

local date = wibox.widget({
    align = 'center',
    -- valign = 'center',
    -- font = 'Gilroy-Medium 20',
    -- font = 'Mont,Mont Medium 20',
    font = 'TTCommons 26',
    -- widget = wibox.widget.textbox('Wednesday, September, 29') -- for testing
    widget = wibox.widget.textclock('%A, %B, %d')
    })

local datetime = wibox.widget({
    {
        widget = clock,
    },
    {
        widget = date,
    },
    -- expand = 'none',
    layout = wibox.layout.fixed.vertical,

})

bar.sidebar = wibox({
    x = 0,
    y = 0,
    ontop = false,
    visible = false,
    type = "dock",
    height = awful.screen.focused().geometry.height,
    width = beautiful.sidebar_width or dpi(450),
    bg = beautiful.bg_dark,
    fg = beautiful.xcolor12,
    border_width = beautiful.border_width or 0,
    border_color = beautiful.bg_dark
    })

bar.sidebar:setup ({

    { -- Time & date widget
        utils.pad_height(20),
        datetime,
        layout = wibox.layout.fixed.vertical,
    },

    utils.pad_height(6),
    layout = wibox.layout.fixed.vertical,
})

return bar
