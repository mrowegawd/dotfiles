local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local user = require("config.user")

-- Main Menu ==========================================================
-- Create a launcher widget and a main menu
-- myawesomemenu = {
--       { "hotkeys", function() return false, hotkeys_popup.show_help end, icons.keyboard},
--       { "restart", awesome.restart, icons.reboot },
--       { "quit", function() awesome.quit() end, icons.poweroff}
-- }
--
-- moxconf = {
--       { "snippets", "bash " .. os.getenv("HOME") .. "/moxconf/exbin/rofi_snippet", icons.submenu },
--       { "bookmarks", "bash " .. os.getenv("HOME") .. "/moxconf/exbin/rofi_bookmarks", icons.submenu },
--       { "glinux", "bash " .. os.getenv("HOME") .. "/moxconf/exbin/rofi_glinux", icons.submenu }
-- }
--
-- mymainmenu = awful.menu(
--     { items = {
--       { "Awesome", myawesomemenu, icons.home },
--       { "Misc", moxconf, icons.submenu },
--       -- { "Debian", debian.menu.Debian_menu.Debian },
--       { "Firefox", user.browser, icons.firefox },
--       { "Terminal", user.terminal, icons.terminal },
--       { "Search", "rofi -padding 410 -show run", icons.search },
--     }
-- })
myawesomemenu = {
      { "hotkeys", function() return false, hotkeys_popup.show_help end },
      { "restart", awesome.restart},
      { "quit", function() awesome.quit() end}
}

moxconf = {
      { "snippets", "bash " .. os.getenv("HOME") .. "/moxconf/exbin/rofi_snippet"},
      { "bookmarks", "bash " .. os.getenv("HOME") .. "/moxconf/exbin/rofi_bookmarks"},
      { "glinux", "bash " .. os.getenv("HOME") .. "/moxconf/exbin/rofi_glinux"}
}

myosmenu = {
      { "shutdown", function() awful.spawn.with_shell("dbus-send --system --print-reply --dest='org.freedesktop.ConsoleKit' /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop") end },
      {   "reboot", function() awful.spawn.with_shell("dbus-send --system --print-reply --dest='org.freedesktop.ConsoleKit' /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart") end },
      { "suspend" , function() awful.spawn.with_shell("dbus-send --system --print-reply --dest='org.freedesktop.ConsoleKit' /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Suspend  boolean:true") end }
}

mymainmenu = awful.menu(
    { items = {
      { "Awesome", myawesomemenu, beautiful.awesome_menu},
      { "Callrofi", moxconf, beautiful.awesome_callrofi},
      -- { "Debian", debian.menu.Debian_menu.Debian },
      { "Firefox", user.browser, beautiful.awesome_browser},
      { "File Manager", user.file_manager, beautiful.awesome_filemanager},
      { "Terminal", user.terminal, beautiful.awesome_term},
      { "Search", "rofi -padding 410 -show run", beautiful.awesome_search},
      { "Quit", myosmenu, beautiful.awesome_exit}
    }
})

return mymainmenu
