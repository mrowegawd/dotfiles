-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- Widget and layout library
-- local wibox = require("wibox")

require("awful.autofocus")

local helpers = {}

-- Notification library
-- local naughty = require("naughty")

helpers.client_menu_toggle_fn = function ()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

return helpers
