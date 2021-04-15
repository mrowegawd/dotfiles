local theme_collection = {
    "manta",        -- 1 --
    "lovelace",     -- 2 --
    "skyfall",      -- 3 --
    "matemers",     -- 4 --
}

local icon_theme_collection = {
    "linebit",        -- 1 --
    "drops",          -- 2 --
}

-- Change this number to use a different icon theme
local icon_theme_name = icon_theme_collection[2]

-- Change this number to use a different theme
local theme_name = theme_collection[4]

-- local volumebar_widget = require("awesome-wm-widgets.volumebar-widget.volumebar")
-- require("volume")

-- Initialization
-- ===================================================================
-- Theme handling library
local beautiful = require("beautiful")
local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/"
beautiful.init( theme_dir .. theme_name .. "/theme.lua" )

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Widget and layout library
local wibox = require("wibox")
require("awful.autofocus")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Load Debian menu entries
local debian = require("debian.menu")
local lain = require("lain")
local markup = lain.util.markup

modkey = "Mod4"

-- Error Handling =====================================================
require("config.err-check")     -- Check errors | Handle runtime errors

-- require("config.menu")
local keys = require("config.keys")
local menu = require("config.menu")
local user = require("config.user")

-- Variable definitions ===============================================

local function runOnce(cmd)
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
end
runOnce(user.terminal) -- entries must be separated by commas

-- Helper Functions ===================================================
-- What would I do without them?
local helpers = require("helpers")
local kampang = require("kampang")

-- Layouts ============================================================
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

-- Menubar configuration
menubar.utils.terminal = user.terminal -- Set the terminal for applications that require it

-- Wallpaper ==========================================================
-- local function set_wallpaper(s)
--     -- Wallpaper
--     if beautiful.wallpaper then
--         local wallpaper = beautiful.wallpaper
--         -- If wallpaper is a function, call it with the screen
--         if type(wallpaper) == "function" then
--             wallpaper = wallpaper(s)
--         end
--
--         -- Method 1: Build in wallpaper function
--         gears.wallpaper.maximized(wallpaper, s, true)
--
--         -- Method 2: Errors
--         -- gears.wallpaper.set(beautiful.color and beautiful.color.bg)
--
--         -- Method 3: Set last wallpaper with feh
--         -- awful.spawn.with_shell(os.getenv("HOME") .. "/.fehbg")
--     end
-- end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
-- screen.connect_signal("property::geometry", set_wallpaper)

-- Tags ===============================================================
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, helpers.client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))


mylauncher = wibox.widget.imagebox()
mylauncher:set_image(beautiful.awesome_icon)
mylauncher:buttons(awful.util.table.join(
  -- Lock
  awful.button({ }, 1,
    function()
      -- local lock = "i3lock -d -p default -c " .. beautiful.bg_focus:gsub("#","")
      local lock = "man"
      awful.spawn(lock, false)
    end
  ),
  -- Reboot
  awful.button({ modkey }, 1,
    function()
      local reboot = "zenity --question --text 'Reboot?' && systemctl reboot"
      awful.spawn(reboot, false)
    end
  ),
  -- Shutdown
  awful.button({ modkey }, 3,
    function()
      local shutdown = "zenity --question --text 'Shut down?' && systemctl poweroff"
      awful.spawn(shutdown, false)
    end
  )
))

-- Create a textclock widget


-- MPD
-- beautiful.musicplr = string.format("%s -e ncmpcpp", user.terminal)
-- mpdicon = wibox.widget.imagebox(beautiful.widget_music)
-- mpdicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)))
-- local mpdicon = wibox.widget.imagebox(beautiful.widget_music)
-- beautiful.mpd = lain.widget.mpd({
--     settings = function()
--         if mpd_now.state == "play" then
--             artist = " " .. mpd_now.artist .. " "
--             title  = mpd_now.title  .. " "
--             mpdicon:set_image(beautiful.widget_music_on)
--         elseif mpd_now.state == "pause" then
--             artist = " mpd "
--             title  = "paused "
--         else
--             artist = ""
--             title  = ""
--             mpdicon:set_image(beautiful.widget_music)
--         end
--
--         widget:set_markup(markup.font(beautiful.font, markup("#EA6F81", artist) .. title))
--     end
-- })

-- mpdicon = wibox.widget.imagebox()
-- beautiful.mpd = lain.widget.mpd({
--     settings = function()
--         if mpd_now.state == "play" then
--             artist = " " .. mpd_now.artist .. " "
--             title  = mpd_now.title  .. " "
--             mpdicon:set_image(beautiful.widget_music_on)
--         elseif mpd_now.state == "pause" then
--             artist = " mpd "
--             title  = "paused "
--         else
--             artist = ""
--             title  = ""
--             mpdicon:set_image(beautiful.widget_music)
--         end
--
--         widget:set_markup(markup.font(beautiful.font, markup("#EA6F81", artist) .. title))
--     end
-- })

-- CPU
-- local cpuwidget = wibox.widget.textbox()
-- vicious.register(cpuwidget, vicious.widgets.cpu,
--         function (widget, args)
-- --                    infojets.update_cpu(args[1])
--           if string.len(args[1]) == 1 then
--             return "☢  " .. args[1] .. "% "
--           else
--             return "☢ " .. args[1] .. "% "
--           end
--         end)
-- cpuwidget:buttons(
--    awful.util.table.join(awful.button({ }, 1,
--         function ()
--           awful.util.spawn(user.terminal .. " -e htop")
--         end),
--           awful.button({ }, 3, function () cpuwidget.width = 1 end)))

awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)


-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }
    -- { rule = { class = "Firefox" },
    --     properties = { tag = tags[1][1] } },

    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- Method 1: Creating round corner for every client
    -- taken from https://www.reddit.com/r/awesomewm/comments/61s020/round_corners_for_every_client/
    c.shape = function(cr,w,h)
        gears.shape.rounded_rect(cr,w,h,10)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--         and awful.client.focus.filter(c) then
--         client.focus = c
--     end
-- end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Startup applications
-- Runs your autostart script, which should include all the commands you
-- would like to run every time AwesomeWM restarts
-- ===================================================================
awful.spawn.with_shell( os.getenv("HOME") .. "/.config/awesome/autostart.sh")
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
