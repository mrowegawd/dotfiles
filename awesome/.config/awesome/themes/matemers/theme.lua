-- REQUIRE ====================================================== {{{
local theme_name         = "matemers"
local theme_assets       = require("beautiful.theme_assets")
local xresources         = require("beautiful.xresources")
local dpi                = xresources.apply_dpi
local xrdb               = xresources.get_current_theme()
local gears              = require("gears")
local vicious            = require("vicious")
-- local gfs                = require("gears.filesystem")
local beautiful          = require("beautiful")
local naughty            = require("naughty")
local lain               = require("lain")
local markup             = lain.util.markup

local awful              = require("awful")
local wibox              = require("wibox")
-- }}}
local theme = {}
-- VARS THEME --------------------------------------------------- {{{
local icon_path          = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/icons/"
local layout_icon_path   = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/layout/"
local titlebar_icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/titlebar/"
local taglist_icon_path  = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/taglist/"

local tip                = titlebar_icon_path --alias to save time
local lip                = layout_icon_path --alias to save time

theme.dir                = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name
theme.wallpaper          = theme.dir .. "/wall.jpg"

theme.xbackground        = xrdb.background or "#1D1F28"
theme.xforeground        = xrdb.foreground or "#FDFDFD"
theme.xcolor0            = xrdb.color0 or "#282A36"
theme.xcolor1            = xrdb.color1 or "#F37F97"
theme.xcolor2            = xrdb.color2 or "#5ADECD"
theme.xcolor3            = xrdb.color3 or "#F2A272"
theme.xcolor4            = xrdb.color4 or "#8897F4"
theme.xcolor5            = xrdb.color5 or "#C574DD"
theme.xcolor6            = xrdb.color6 or "#79E6F3"
theme.xcolor7            = xrdb.color7 or "#FDFDFD"
theme.xcolor8            = xrdb.color8 or "#414458"
theme.xcolor9            = xrdb.color9 or "#FF4971"
theme.xcolor10           = xrdb.color10 or  "#18E3C8"
theme.xcolor11           = xrdb.color11 or  "#FF8037"
theme.xcolor12           = xrdb.color12 or  "#556FFF"
theme.xcolor13           = xrdb.color13 or  "#B043D1"
theme.xcolor14           = xrdb.color14 or  "#3FDCEE"
theme.xcolor15           = xrdb.color15 or  "#BEBEC1"

local font_name          = "Liberation Mono"
local font_size          = "12"

local border_gap         = dpi(3)
local border_radius      = dpi(6)
local border_width       = dpi(0)

local menu_border_width  = border_width
local menu_height        = dpi(35)
local menu_width         = dpi(180)
-- Fonts ===========================================================
theme.font               = font_name .. " " ..                         font_size
theme.font_bold          = font_name .. " " .. "Bold"        .. " " .. font_size
theme.font_italic        = font_name .. " " .. "Italic"      .. " " .. font_size
theme.font_bold_italic   = font_name .. " " .. "Bold Italic" .. " " .. font_size
theme.font_big           = font_name .. " " .. "Bold"        .. " 16"

theme.iconFont           = "Font Awesome 5 Free Regular 9"
theme.iconFont8          = "Font Awesome 5 Free 11"
theme.iconFont10         = "Font Awesome 5 Free 10"
theme.materialIconFont   = "Material Icons Regular 10"
theme.font_big           = "Material Icons Regular "  .. " 20"
theme.taglist_font       = "Mplus 1p Medium 8.7"

theme.bg_dark            = theme.xbackground
theme.bg_normal          = theme.xcolor0
theme.bg_focus           = theme.xcolor8
theme.bg_urgent          = theme.xcolor8
theme.bg_minimize        = theme.xcolor8
theme.bg_systray         = theme.xcolor8

theme.fg_normal          = theme.xcolor8
theme.fg_focus           = theme.xcolor4
theme.fg_urgent          = theme.xcolor3
theme.fg_minimize        = theme.xcolor8

-- Gaps ===========================================
theme.useless_gap        = border_gap
theme.border_width       = border_width
theme.border_normal      = theme.xbackground
theme.border_focus       = theme.bg_focus
theme.border_marked      = theme.fg_focus
-- theme.border_color       = border_color
-- theme.border_radius   = border_radius

-- Menu ===========================================
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.awesome_icon              = icon_path.."awesome.png"
theme.menu_submenu_icon         = icon_path.."submenu.png"
theme.menu_height               = menu_height
theme.menu_width                = menu_width
theme.menu_bg_normal            = theme.xcolor0
theme.menu_fg_normal            = theme.xcolor7
theme.menu_bg_focus             = theme.xcolor8 .. "55"
theme.menu_fg_focus             = theme.xcolor7
theme.menu_border_width         = menu_border_width
theme.menu_border_color         = theme.menu_bg_focus

-- Titlebars ======================================
-- (Titlebar items can be customized in titlebars.lua)
theme.titlebars_enabled         = true
theme.titlebar_size             = dpi(2)
theme.titlebar_title_enabled    = false
theme.titlebar_font             = "sans bold 9"
-- Window title alignment: left, right, center
theme.titlebar_title_align      = "center"
-- Titlebar position: top, bottom, left, right
theme.titlebar_position         = "top"
-- Use 4 titlebars around the window to imitate borders
theme.titlebars_imitate_borders = false
theme.titlebar_bg               = theme.xcolor0
-- theme.titlebar_bg = theme.xbackground
-- theme.titlebar_bg_focus = theme.xcolor12
-- theme.titlebar_bg_normal = theme.xcolor8
theme.titlebar_fg_focus         = theme.color9
theme.titlebar_fg_normal        = theme.xcolor8
--theme.titlebar_fg = theme.xcolor7

theme.snap_bg = theme.bg_focus
if theme.border_width == 0 then
    theme.snap_border_width = dpi(8)
else
    theme.snap_border_width = dpi(theme.border_width * 2)
end

theme.tooltip_fg                = theme.fg_normal
theme.tooltip_bg                = theme.bg_normal
-- }}}
-- WIBAR -------------------------------------------------------- {{{
-- (Bar items can be customized in bars.lua)
theme.wibar_position            = "bottom"
theme.wibar_ontop               = false
theme.wibar_height              = dpi(35)
theme.wibar_fg                  = theme.xcolor7
theme.wibar_bg                  = theme.xcolor0
--theme.wibar_opacity           = 0.7
theme.wibar_border_color        = theme.xcolor0
theme.wibar_border_width        = dpi(0)
theme.wibar_border_radius       = dpi(0)
--theme.wibar_width = screen_width - theme.screen_margin * 4 -theme.wibar_border_width * 2
-- theme.wibar_width = dpi(565)
--theme.wibar_x = screen_width / 2 - theme.wibar_width - theme.screen_margin * 2
--theme.wibar_x = theme.screen_margin * 2
--theme.wibar_x = screen_width - theme.wibar_width - theme.wibar_border_width * 2 - theme.screen_margin * 2
--theme.wibar_y = theme.screen_margin * 2
-- }}}
-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme, theme.fg_normal)
 --TASKLIST ----------------------------------------------------- {{{
theme.tasklist_disable_icon     = true
theme.tasklist_plain_task_name  = true
theme.tasklist_bg_focus         = theme.xcolor0
theme.tasklist_fg_focus         = theme.xcolor4
theme.tasklist_bg_normal        = theme.xcolor0
theme.tasklist_fg_normal        = theme.xcolor15
theme.tasklist_bg_minimize      = theme.xcolor0
theme.tasklist_fg_minimize      = theme.fg_minimize
theme.tasklist_bg_urgent        = theme.xcolor0
theme.tasklist_fg_urgent        = theme.xcolor3
theme.tasklist_spacing          = 10
theme.tasklist_align            = "center"
-- Recolor titlebar icons:

--theme.taglist_item_roundness = 0
theme.taglist_item_roundness    = theme.border_radius
-- Generate taglist squares:
local taglist_square_size       = dpi(3)
theme.taglist_squares_sel       = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_focus
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)
-- }}}
-- SIDEBAR ------------------------------------------------------ {{{
-- (Sidebar items can be customized in sidebar.lua)
theme.sidebar_bg                = theme.xcolor0
theme.sidebar_fg                = theme.xcolor7
theme.sidebar_opacity           = 1
-- theme.sidebar_position = "left" -- left or right
theme.sidebar_width             = dpi(300)
theme.sidebar_height            = screen_height
theme.sidebar_x                 = 0
theme.sidebar_y                 = 0
theme.sidebar_border_radius     = 0
-- }}}
-- PROMPT ------------------------------------------------------- {{{
theme.prompt_fg                 = theme.xcolor14
-- }}}
-- EXIT SCREEN -------------------------------------------------- {{{
theme.exit_screen_bg                                  = theme.xcolor0 .. "CC"
theme.exit_screen_fg                                  = theme.xcolor7
theme.exit_screen_font                                = "sans 20"
theme.exit_screen_icon_size                           = dpi(180)

-- Exit screen icons
theme.exit_icon                                       = icon_path .. "exit.png"
theme.poweroff_icon                                   = icon_path .. "poweroff.png"
theme.reboot_icon                                     = icon_path .. "reboot.png"
theme.suspend_icon                                    = icon_path .. "suspend.png"
theme.lock_icon                                       = icon_path .. "lock.png"
theme.hibernate_icon                                  = icon_path .. "hibernate.png"
-- theme.sidebar_border_radius                          = theme.border_radius
-- }}}
-- TITLEBAR ----------------------------------------------------- {{{
theme.titlebar_close_button_normal                    = tip .. "/close_normal.svg"
theme.titlebar_close_button_focus                     = tip .. "/close_focus.svg"
theme.titlebar_minimize_button_normal                 = tip .. "/minimize_normal.svg"
theme.titlebar_minimize_button_focus                  = tip .. "/minimize_focus.svg"
theme.titlebar_ontop_button_normal_inactive           = tip .. "/ontop_normal_inactive.svg"
theme.titlebar_ontop_button_focus_inactive            = tip .. "/ontop_focus_inactive.svg"
theme.titlebar_ontop_button_normal_active             = tip .. "/ontop_normal_active.svg"
theme.titlebar_ontop_button_focus_active              = tip .. "/ontop_focus_active.svg"
theme.titlebar_sticky_button_normal_inactive          = tip .. "/sticky_normal_inactive.svg"
theme.titlebar_sticky_button_focus_inactive           = tip .. "/sticky_focus_inactive.svg"
theme.titlebar_sticky_button_normal_active            = tip .. "/sticky_normal_active.svg"
theme.titlebar_sticky_button_focus_active             = tip .. "/sticky_focus_active.svg"
theme.titlebar_floating_button_normal_inactive        = tip .. "/floating_normal_inactive.svg"
theme.titlebar_floating_button_focus_inactive         = tip .. "/floating_focus_inactive.svg"
theme.titlebar_floating_button_normal_active          = tip .. "/floating_normal_active.svg"
theme.titlebar_floating_button_focus_active           = tip .. "/floating_focus_active.svg"
theme.titlebar_maximized_button_normal_inactive       = tip .. "/maximized_normal_inactive.svg"
theme.titlebar_maximized_button_focus_inactive        = tip .. "/maximized_focus_inactive.svg"
theme.titlebar_maximized_button_normal_active         = tip .. "/maximized_normal_active.svg"
theme.titlebar_maximized_button_focus_active          = tip .. "/maximized_focus_active.svg"
-- (hover)
theme.titlebar_close_button_normal_hover              = tip .. "close_normal_hover.svg"
theme.titlebar_close_button_focus_hover               = tip .. "close_focus_hover.svg"
theme.titlebar_minimize_button_normal_hover           = tip .. "minimize_normal_hover.svg"
theme.titlebar_minimize_button_focus_hover            = tip .. "minimize_focus_hover.svg"
theme.titlebar_ontop_button_normal_inactive_hover     = tip .. "ontop_normal_inactive_hover.svg"
theme.titlebar_ontop_button_focus_inactive_hover      = tip .. "ontop_focus_inactive_hover.svg"
theme.titlebar_ontop_button_normal_active_hover       = tip .. "ontop_normal_active_hover.svg"
theme.titlebar_ontop_button_focus_active_hover        = tip .. "ontop_focus_active_hover.svg"
theme.titlebar_sticky_button_normal_inactive_hover    = tip .. "sticky_normal_inactive_hover.svg"
theme.titlebar_sticky_button_focus_inactive_hover     = tip .. "sticky_focus_inactive_hover.svg"
theme.titlebar_sticky_button_normal_active_hover      = tip .. "sticky_normal_active_hover.svg"
theme.titlebar_sticky_button_focus_active_hover       = tip .. "sticky_focus_active_hover.svg"
theme.titlebar_floating_button_normal_inactive_hover  = tip .. "floating_normal_inactive_hover.svg"
theme.titlebar_floating_button_focus_inactive_hover   = tip .. "floating_focus_inactive_hover.svg"
theme.titlebar_floating_button_normal_active_hover    = tip .. "floating_normal_active_hover.svg"
theme.titlebar_floating_button_focus_active_hover     = tip .. "floating_focus_active_hover.svg"
theme.titlebar_maximized_button_normal_inactive_hover = tip .. "maximized_normal_inactive_hover.svg"
theme.titlebar_maximized_button_focus_inactive_hover  = tip .. "maximized_focus_inactive_hover.svg"
theme.titlebar_maximized_button_normal_active_hover   = tip .. "maximized_normal_active_hover.svg"
theme.titlebar_maximized_button_focus_active_hover    = tip .. "maximized_focus_active_hover.svg"
-- }}}
-- LAYOUT ------------------------------------------------------- {{{
theme.layout_fairh                                    = lip .. "fair.svg"
theme.layout_fairv                                    = lip .. "fair.svg"
theme.layout_floating                                 = lip .. "floating.svg"
theme.layout_magnifier                                = lip .. "magnifier.svg"
theme.layout_max                                      = lip .. "max.svg"
theme.layout_fullscreen                               = lip .. "fullscreen.svg"
theme.layout_tilebottom                               = lip .. "tilebottom.svg"
theme.layout_tileleft                                 = lip .. "tileleft.svg"
theme.layout_tile                                     = lip .. "tile.svg"
theme.layout_tiletop                                  = lip .. "tiletop.svg"
theme.layout_spiral                                   = lip .. "spiral.svg"
theme.layout_dwindle                                  = lip .. "dwindlew.svg"
theme.layout_cornernw                                 = lip .. "cornernw.svg"
theme.layout_cornerne                                 = lip .. "cornerne.svg"
theme.layout_cornersw                                 = lip .. "cornersw.svg"
theme.layout_cornerse                                 = lip .. "cornerse.svg"
-- }}}
-- TOOLTIP ------------------------------------------------------ {{{
theme.tooltip_fg                                      = theme.xcolor9
theme.tooltip_bg                                      = theme.xbackground
theme.tooltip_border_color                            = theme.border_focus
-- }}}
-- NOTIFICATIONS ------------------------------------------------ {{{
-- ============================
-- Note: Some of these options are ignored by my custom
-- notification widget_template
-- ============================
-- Position: bottom_left, bottom_right, bottom_middle,
--         top_left, top_right, top_middle
theme.notification_position               = "top_left"
theme.notification_border_width           = theme.border_width
theme.notification_fg                     = theme.xforeground
theme.notification_bg                     = theme.xbackground
theme.notification_border_color           = theme.menu_border_color
theme.notification_icon_size              = 80
theme.notification_opacity                = 9
theme.notification_max_width              = 600
theme.notification_max_height             = 400
theme.notification_margin                 = 20
-- theme.notification_shape                  = function(cr, w, h)
--                                                 gears.shape.rounded_rect(cr, w, h, border_radius or 0)
--                                             end

naughty.config.presets.normal             = {
                                                font         = "TamzenForPowerline 12",
                                                fg           = theme.notification_fg,
                                                bg           = theme.notification_bg,
                                                border_width = theme.notification_border_width,
                                                margin       = theme.notification_margin,
                                                timeout      = 10,
                                            }

naughty.config.presets.low                = {
                                                font         = "sans 12",
                                                fg           = theme.notification_fg,
                                                bg           = theme.notification_bg,
                                                border_width = theme.notification_border_width,
                                                margin       = theme.notification_margin,
                                                timeout      = 10,
                                            }
naughty.config.presets.ok                 = {
                                                font         = "sans 12",
                                                fg           = theme.xcolor4,
                                                bg           = theme.notification_bg,
                                                border_width = theme.notification_border_width,
                                                margin       = theme.notification_margin,
                                                timeout      = 10,
                                            }

naughty.config.presets.info               = {
                                                font         = "sans bold 12",
                                                fg           = theme.xcolor5,
                                                bg           = theme.notification_bg,
                                                border_width = theme.notification_border_width,
                                                margin       = theme.notification_margin,
                                                timeout      = 10,
                                            }

naughty.config.presets.warn               = {
                                                font         = "sans bold 15",
                                                fg           = theme.xcolor7,
                                                bg           = theme.notification_bg,
                                                border_width = theme.notification_border_width,
                                                margin       = theme.notification_margin,
                                                timeout      = 10,
                                            }

naughty.config.presets.critical           = {
                                                font         = "sans bold 15",
                                                fg           = theme.xcolor7,
                                                bg           = theme.xcolor2,
                                                border_width = theme.notification_border_width,
                                                margin       = theme.notification_margin,
                                                timeout      = 0,
                                            }
-- }}}
-- WIDGET THEME ================================================= {{{
-- Mpd-icon ----
theme.widget_music                                    = icon_path .. "muted.png"
theme.widget_music_on                                 = icon_path .. "music.png"

theme.bottom_bar                                      = icon_path .. "bottom_bar.png"
theme.mpdl                                            = icon_path .. "editor.png"
theme.nex                                             = icon_path .. "ram.png"
theme.prev                                            = icon_path .. "ram.png"

theme.stop                                            = icon_path .. "start.png"
theme.pause                                           = icon_path .. "muted.png"

theme.play                                            = icon_path .. "start.png"

-- Menu-Icon ---
theme.awesome_menu                                    = icon_path .. "awesome.png"
theme.awesome_callrofi                                = icon_path .. "manual.png"
theme.awesome_browser                                 = icon_path .. "firefox.png"
theme.awesome_filemanager                             = icon_path .. "files.png"
theme.awesome_term                                    = icon_path .. "terminal.png"
theme.awesome_search                                  = icon_path .. "search.png"
theme.awesome_exit                                    = icon_path .. "exit.png"
-- }}}

-- MISC ========================================================= {{{
-- awful.util.tagnames = {" ", "", "", "", "", "", "", "", "" }
awful.util.tagnames = {"1", "2", "3", "4", "5" }

local function format_time(s)
  local seconds = tonumber(s)
  if seconds then
    return string.format("%d:%.2d", math.floor(seconds/60), seconds%60)
  else
    return 0
  end
end
-- }}}

-- WID.SEPARATOR ------------------------------------------------ {{{
local spaceH10 = wibox.widget {
    widget = wibox.widget.separator,
    orientation = "vertical",
    forced_width = 100,
    thickness = 10,
    color = "#00000000",
}

-- Separator
local vert_sep = wibox.widget {
    widget = separator,
    orientation = 'vertical',
    border_width = 2,
    color = '#000000',
}
-- }}}

-- WID.TEMP ----------------------------------------------------- {{{
widget_temp = lain.widget.temp({
  tempfile = TEMPFILE,
  settings = function ()
    widget:set_markup(markup.font(theme.font, "") .. markup.font(theme.font, " " .. coretemp_now .. "° "))
  end
})
-- }}}
-- WID.MPD ------------------------------------------------------ {{{
-- mpd toggle --------------------------- {{{
theme.mpd_toggle = wibox.widget.textbox()
vicious.register(
    theme.mpd_toggle,
    vicious.widgets.mpd,
    function(widget, args)
        local label = {["Play"] = "", ["Pause"] = "", ["Stop"] = "" }
            return ("<span font=\"".. theme.iconFont .."\">%s</span> "):format(label[args["{state}"]])
 end)

theme.mpd_toggle:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        os.execute("mpc toggle")
        vicious.force({theme.mpdwidget, theme.mpd_prev, theme.mpd_toggle, theme.mpd_next})
    end),
    awful.button({}, 3, function()
        os.execute("mpc stop")
        vicious.force({theme.mpdwidget, theme.mpd_prev, theme.mpd_toggle, theme.mpd_next})
    end)
))
-- }}]
--- }}}
-- mpd prev ----------------------------- {{{
theme.mpd_prev = wibox.widget.textbox()
vicious.register(
    theme.mpd_prev,
    vicious.widgets.mpd,
    function(widget, args)
        if args["{state}"] == "Stop" then
            return " "
        else
            return (" <span font=\"".. theme.iconFont .."\"></span> ")
        end
    end)

theme.mpd_prev:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        os.execute("mpc prev")
        vicious.force({theme.mpdwidget, theme.mpd_prev, theme.mpd_toggle, theme.mpd_next})
    end)
))
-- }}]
--- }}}
-- mpd next ----------------------------- {{{
theme.mpd_next = wibox.widget.textbox()
vicious.register(
    theme.mpd_next,
    vicious.widgets.mpd,
    function(widget, args)
        if args["{state}"] == "Stop" then
            return ""
        else
            return ("<span font=\"".. theme.iconFont .."\"></span> ")
        end
    end)

theme.mpd_next:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        os.execute("mpc next")
        vicious.force({theme.mpdwidget, theme.mpd_prev, theme.mpd_toggle, theme.mpd_next})
    end)
))

local justText = wibox.widget.textbox(" <span  font=\"".. theme.iconFont .."\"></span>")

theme.mpd_random = wibox.widget.textbox()
vicious.register(
    theme.mpd_random,
    vicious.widgets.mpd,
    function(widget, warg)
        if warg["{random}"] == true then
          return ("<span font=\"".. theme.iconFont .."\">1</span> ")
        elseif warg["{random}"] == false then
          return ("<span font=\"".. theme.iconFont .."\">0</span> ")
        else
          return ("<span font=\"".. theme.iconFont .."\">8</span> ")
        end
    end)

theme.mpd_random:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        os.execute("mpc random")
        vicious.force({theme.mpdwidget, theme.mpd_random})
    end)
))

local justText1 = wibox.widget.textbox(" <span font=\"".. theme.iconFont .."\"></span>")
-- }}]
--- }}}
--}}}
-- WID.ALSAVOL -------------------------------------------------- {{{
local vol_icon = wibox.widget.textbox()
theme.volume = lain.widget.alsa {
    settings = function()
        if volume_now.status == "off" then
            vol_icon.markup = "<span font=\"".. theme.iconFont10 .."\"></span> "
        elseif tonumber(volume_now.level) == 0 then
            vol_icon.markup = "<span font=\"".. theme.iconFont .."\"></span> "
        elseif tonumber(volume_now.level) < 50 then
            vol_icon.markup = "<span font=\"".. theme.iconFont .."\"></span> "
        else
            vol_icon.markup = "<span font=\"".. theme.iconFont .."\"></span> "
        end

        widget:set_markup(markup.fontfg(theme.font, theme.xcolor3, volume_now.level .. "%"))

        if theme.volume.manual then
            if theme.volume.notification then
                naughty.destroy(theme.volume.notification)
            end

            if volume_now.status == "off" then
                vol_text = "Muted"
            else
                vol_text = " " .. volume_now.level .. "%"
            end

            if client.focus and client.focus.fullscreen or volume_now.status ~= volume_before then
                theme.volume.notification = naughty.notify {
                    title = "Audio",
                    text = vol_text,
                }
            end

            theme.volume.manual = false
        end
        volume_before = volume_now.status
    end,
}
-- Initial notification
theme.volume.manual = true
theme.volume.update()

local vol_widget =
    wibox.widget {
                    {
                        layout = wibox.layout.fixed.horizontal,
                        vol_icon,
                        theme.volume.widget,
                    },
                    top = 0,
                    bottom = 0,
                    left = 13,
                    right = 13,
                    widget = wibox.container.margin
                }

vol_widget:buttons(gears.table.join(
    awful.button({ }, 1, function()
        awful.spawn.easy_async(string.format("amixer -q set %s toggle", theme.volume.channel),
        function(stdout, stderr, reason, exit_code) --luacheck: no unused args
            theme.volume.manual = true
            theme.volume.update()
        end)
    end),
    awful.button({ }, 5, function()
        awful.spawn.easy_async(string.format("amixer -q set %s 3%%-", theme.volume.channel),
        function(stdout, stderr, reason, exit_code) --luacheck: no unused args
            theme.volume.update()
        end)
    end),
    awful.button({ }, 4, function()
        awful.spawn.easy_async(string.format("amixer -q set %s 3%%+", theme.volume.channel),
        function(stdout, stderr, reason, exit_code) --luacheck: no unused args
            theme.volume.update()
        end)
    end),
    awful.button({}, 3, function()
        os.execute("pulseaudio-equalizer toggle")
    end)
))
-- }}}
-- WID.CLOCK ---------------------------------------------------- {{{
os.setlocale(os.getenv("LANG")) -- to localize the clock
local clock = awful.widget.watch(
    "date +'%R'", 5,
    function(widget, stdout)
        widget:set_markup(markup.fontfg(theme.font_bold, theme.xforeground, stdout))
    end
)

local clock_widget =
    wibox.widget {
                    {
                        layout = wibox.layout.fixed.horizontal,
                        clock,
                    },
                    top = 0,
                    bottom = 0,
                    left = 13,
                    right = 13,
                    widget = wibox.container.margin
                }

-- Calendar
theme.cal = lain.widget.cal {
    -- cal = "cal --color=always --monday",
    cal = "cal --color=always",
    attach_to = { clock_widget },
    icons = "",
    notification_preset = naughty.config.presets.normal,
}
-- }}}
-- WID.CPU ------------------------------------------------------ {{{
local cpu_icon = wibox.widget.textbox("<span font=\"".. theme.iconFont .."\"></span> ")
local cpu = lain.widget.cpu {
    timeout = 5,
    settings = function()
        local _color = bar_fg
        local _font = theme.font

        if tonumber(cpu_now.usage) >= 90 then
            -- _color = colors.red_2
            _color = theme.xcolor4
        elseif tonumber(cpu_now.usage) >= 80 then
            -- _color = colors.orange_2
            _color = theme.xcolor5
        elseif tonumber(cpu_now.usage) >= 70 then
            -- _color = colors.yellow_2
            _color = theme.xbackground
        end

        widget:set_markup(markup.fontfg(theme.font, theme.xcolor3,  cpu_now.usage .. "%"))

        widget.core  = cpu_now
    end,
}

local cpu_widget =
    wibox.widget {
                    {
                        layout = wibox.layout.fixed.horizontal,
                        cpu_icon,
                        cpu.widget,
                    },
                    top = 0,
                    bottom = 0,
                    left = 13,
                    right = 13,
                    widget = wibox.container.margin
                }

cpu_widget:buttons(awful.button({ }, 1, function()
    awful.spawn("kitty -e htop -s PERCENT_CPU & disown")
end))
-- }}}
-- WID.MEM ------------------------------------------------------ {{{
-- theme.memory_trolling = icon.path .. "reboot.png"
-- local memory_ram = wibox.widget.imagebox(theme.memory_all)
-- local memory = lain.widget.mem({
--     settings = function()
--             widget:set_markup(markup.fontfg(theme.font, "#FFFFFF", "" .. mem_now.used .. "M (" .. mem_now.perc .. "%)"))
--     end
-- })
-- local memwidget = wibox.container.background(memory.widget, theme.xbackground, gears.shape.rectangle)
-- memorywidget = wibox.container.margin(memwidget, 0, 0, 5, 5)

local mem_icon = wibox.widget.textbox("<span font=\"".. theme.iconFont .."\"></span> ")
local mem = lain.widget.mem {
    timeout = 5,
    settings = function()
        local _color = bar_fg
        local _font = theme.font

        if tonumber(mem_now.perc) >= 90 then
            _color = theme.xcolor2
        elseif tonumber(mem_now.perc) >= 80 then
            _color = theme.xcolor3
        elseif tonumber(mem_now.perc) >= 70 then
            _color = theme.xcolor4
        end

        widget:set_markup(markup.fontfg(theme.font, theme.xcolor6 , mem_now.perc .. "%"))

        widget.used  = mem_now.used
        widget.total = mem_now.total
        widget.free  = mem_now.free
        widget.buf   = mem_now.buf
        widget.cache = mem_now.cache
        widget.swap  = mem_now.swap
        widget.swapf = mem_now.swapf
        widget.srec  = mem_now.srec
    end,
}

local mem_widget =
    wibox.widget {
                    {
                        layout = wibox.layout.fixed.horizontal,
                        mem_icon,
                        mem.widget,
                    },
                    top = 0,
                    bottom = 0,
                    left = 13,
                    right = 13,
                    widget = wibox.container.margin
                }

mem_widget:buttons(awful.button({ }, 1, function()
    if mem_widget.notification then
        naughty.destroy(mem_widget.notification)
    end
    mem.update()
    mem_widget.notification = naughty.notify {
        title = "Memory",
        text = string.format("Total:      \t\t%.2fGB\n", tonumber(mem.widget.total) / 1024)
            .. string.format("Used:       \t\t%.2fGB\n", tonumber(mem.widget.used ) / 1024)
            .. string.format("Free:       \t\t%.2fGB\n", tonumber(mem.widget.free ) / 1024)
            .. string.format("Buffer:     \t\t%.2fGB\n", tonumber(mem.widget.buf  ) / 1024)
            .. string.format("Cache:    \t\t%.2fGB\n", tonumber(mem.widget.cache) / 1024)
            .. string.format("Swap:       \t\t%.2fGB\n", tonumber(mem.widget.swap ) / 1024)
            .. string.format("Swapf:    \t\t%.2fGB\n", tonumber(mem.widget.swapf) / 1024)
            .. string.format("Srec:       \t\t%.2fGB"  , tonumber(mem.widget.srec ) / 1024),
        timeout = 7,
    }
end))

-- }}}
-- WID.NCMPCPP -------------------------------------------------- {{{
local ncmpcpp = wibox.widget.textbox("<span font=\"".. theme.iconFont .."\"></span>")

local ncmpcpp_widget =
    wibox.widget {
                    {
                        layout = wibox.layout.fixed.horizontal,
                        ncmpcpp,
                    },
                    top = 0,
                    bottom = 0,
                    left = 13,
                    right = 13,
                    widget = wibox.container.margin
                }

ncmpcpp_widget:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.spawn("kitty -e ncmpcpp")
    end),
    awful.button({}, 3, function()
        awful.spawn(os.getenv("HOME") .. "/.ncmpcpp/mpdnotify")
    end)
))
-- }}}

-- SHAPE ======================================================== {{{
local shape_left = function(cr, width, height)
  gears.shape.parallelogram(cr, width, height, width-10)
end

local shape_right = function(cr, width, height)
  -- gears.shape.transform(gears.shape.parallelogram) : translate(0, 0)(cr, width, height, width-10)
    gears.shape.transform(gears.shape.rounded_rect) : translate(0,0) (cr,width,height, 20)
end

local shape_end_right = function(cr, width, height)
  gears.shape.transform(shape.isosceles_triangle) : rotate_at(35, 35, math.pi/2)(cr,width,height)
end
-- }}}

-- RESET SCREEN ------------------------------------------------- {{{
function theme.at_screen_connect(s)
    -- Wallpaper
    -- set_wallpaper(s)

    -- local l = awful.layout.suit -- Alias to save time :)
    --
    s.quake = lain.util.quake({ app = awful.util.terminal })
    -- local layouts = {
    --   l.tile, l.tile, l.max, l.floating , l.max,
    --   l.tile, l.tile, l.tile, l.max, l.max
    -- }
    --
    if type(wallpaper) == "function" then
            theme.wallpaper = theme.wallpaper(s)
    end
    gears.wallpaper.maximized(theme.wallpaper, s, true)

    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    s.mypromptbox = awful.widget.prompt()

    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(
            s, awful.widget.taglist.filter.all, awful.util.taglist_buttons, { bg_focus = theme.xcolor2 })

    mytaglistcont = wibox.container.background(s.mytaglist, theme.bg_color, gears.shape.rectangle)

    -- wibox.container.margin(widget, left, right, top, bottom)
    s.mytag = wibox.container.margin(mytaglistcont, 5, 5, 5, 5)

	-- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(
            s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons,
            { bg_focus = theme.bg_focus,
              shape = gears.shape.rectangle,
              shape_border_width = 5,
              shape_border_color = theme.tasklist_bg_normal,
              align = "center" })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 32 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- first,
            s.mytag,
            -- spr_small,
            -- s.mylayoutbox,
            -- spr_small,
            -- s.mypromptbox,
        },
        nil, -- Middle widget

        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- wibox.widget.systray(),
            -- Layout box
            {
                {
                    {
                        layout = wibox.layout.fixed.horizontal,
                        s.mylayoutbox
                    },
                top = 2,
                bottom = 2,
                left = 15,
                right = 15,
                widget = wibox.container.margin
                },
            shape              = shape_left,
            bg                 = theme.border_focus,
            widget             = wibox.container.background
            },
            {
                {
                    {
                        layout = wibox.layout.fixed.horizontal,
                        theme.mpd_prev, space,
                        theme.mpd_toggle, space,
                        theme.mpd_next, space,
                        justText, space,
                        -- theme.mpd_random, space,
                        justText1, space
                    },
                left = 13,
                right = 13,
                widget = wibox.container.margin
                },
            shape              = shape_left,
            bg                 = theme.border_focus,
            widget             = wibox.container.background
            },
            {
                ncmpcpp_widget,
                shape              = shape_left,
                bg                 = theme.border_focus,
                widget             = wibox.container.background
            },
            -- cpu
            {
                cpu_widget,
                shape              = shape_right,
                bg                 = theme.border_focus,
                widget             = wibox.container.background
            },
            -- Memory
            {
                mem_widget,
                shape              = shape_right,
                bg                 = theme.border_focus,
                widget             = wibox.container.background
            },
            {
                vol_widget,
                shape              = shape_right,
                bg                 = theme.border_focus,
                widget             = wibox.container.background
            },
            {
                clock_widget,
                shape              = shape_right,
                bg                 = theme.border_focus,
                widget             = wibox.container.background
            },

    },
    }

    -- Create the bottom wibox
    s.mybottomwibox = awful.wibar({ position = "bottom", screen = s, border_width = 0, height = 30 })
    -- s.borderwibox = awful.wibar({ position = "bottom", screen = s, height = 1, bg = theme.fg_focus, x = 0, y = 33})

    -- Add widgets to the bottom wibox
    s.mybottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
        },
        -- s.mytasklist, -- Middle widget
        nil,
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- spr_bottom_right,
            -- netdown_icon,
            -- networkwidget,
            -- netup_icon,
            bottom_bar,
            -- memorywidget,
            -- bottom_bar,
            -- currencywidget,
            -- bottom_bar,
            -- weatherwidget_icon,
            -- weatherwidget,
        },
    }
end
-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
