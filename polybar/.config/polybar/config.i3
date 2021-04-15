# vim: foldmethod=marker foldlevel=0 ft=dosini
# ░░░░█▀█░█▀█░█░░░█░█░█▀▄░█▀█░█▀▄
# ░░░░█▀▀░█░█░█░░░░█░░█▀▄░█▀█░█▀▄
# ░▀░░▀░░░▀▀▀░▀▀▀░░▀░░▀▀░░▀░▀░▀░▀
# #########################################
# VARS COLOR ------------------------------ {{{
# ------------------------
[colors]
background      = ${xrdb:*.background:#222}
foreground      = ${xrdb:*.color15:#222}

active          = ${xrdb:*.color6:#222}
inactive        = ${xrdb:*.color12:#222}

highlight       = ${xrdb:*.color1:#222}
error           = ${xrdb:*.color4:#222}
# }}}

# #########################################
# BARSET ---------------------------------- {{{
# ------------------------
[global/wm]
margin-top             = 0
margin-bottom          = 0

[settings]
throttle-output        = 5
throttle-output-for    = 10
throttle-input-for     = 30
screenchange-reload    = true
compositing-background = over
compositing-foreground = over
compositing-overline   = over
compositing-underline  = over
compositing-border     = over

[bar/top]
#monitor                = HDMI-0
override-redirect      = false
width                  = 100%
height                 = 22
bottom                 = false
fixed-center           = true
offset-x               = 0
offset-y               = 0
radius                 = 0.0

background             = ${colors.background}
; foreground             = ${colors.foreground}

line-size              = 0
line-color             = #000000000

border-size            = 0
border-color           = #000000000

enable-ipc             = true

module-margin-left     = 1
module-margin-right    = 1

padding-left           = 0
padding-right          = 0
margin-left            = 0
margin-right           = 0

# use *.otf font extension
font-0                 = DroidSansMono Nerd Font:size=8;1
font-1                 = DroidSansMono Nerd Font:size=8:style=regular;1
font-2                 = siji:size=8;1
font-3                 = FuraCode NF:size=8;1
font-4                 = Material-Design-Iconic-Font:size=8;1

# separator = " "
; modules-left      = appmenu lockme alsa i3
modules-left           = appmenu lockme i3 xwindow
modules-center         =
modules-right          = pomo todo updates date time

# TRAY -------------------
# ------------------------
tray-position          = right
tray-padding           = 10
tray-background        = ${colors.background}

[bar/bottom]
bottom                 = true
width                  = 100%
height                 = 22

modules-left           = cpu memory alsa
modules-center         = mpd2
modules-right          = filesystem temperature powermenu

; background             = #0000000
background             = ${colors.background}

underline-size         = 2
underline-color        = #FF0000

spacing                = 2
padding-left           = 1
padding-right          = 1
module-margin-left     = 1
module-margin-right    = 1

;font-N = <fontconfig pattern>;<vertical offset>
font-0 = DroidSansMono Nerd Font:size=8;1
font-1 = siji:pixelsize=8;1
font-2 = Font Awesome 5 Brands:size=8;1
font-3 = Hack Nerd Font Complete:pixelsize=8;1
font-4 = Material-Design-Iconic-Font:pixelsize=8;1

# }}}

# #########################################
# X - WINDOW ------------------------------ {{{
[module/xwindow]
type = internal/xwindow
format-foreground = ${colors.foreground}
format-padding = 1
label = %title:0:20: ...%

; [module/xkeyboard]
; type = internal/xkeyboard
; format-volume = <ramp-volume><label-volume>
; blacklist-0 = num lock
; label-layout = %{F#55}%{F-} %layout%
; label-layout-underline = ${colors.highlight}
; label-indicator-padding = 2
; label-indicator-margin = 1
; label-indicator-background = ${colors.highlight}
; label-indicator-underline = ${colors.highlight}
# }}}

# #########################################
# SYS ------------------------------------- {{{
[module/filesystem]
type = internal/fs
interval = 25

mount-0 = /

label-mounted =  HD %mountpoint% %percentage_used%% of %total%
label-mounted-foreground = ${colors.active}
label-unmounted = %mountpoint% not mounted
label-unmounted-foreground = ${colors.error}


[module/cpu]
type = internal/cpu
interval = 2
format-underline =
label =  CPU %percentage:2%%
label-foreground = ${colors.active}

[module/memory]
type = internal/memory
interval = 2
format-underline =
label =  RAM %percentage_used%%
label-foreground = ${colors.active}


[module/temperature]
type = internal/temperature
thermal-zone = 0
warn-temperature = 60

format = <ramp><label>
format-foreground = ${colors.foreground}
format-underline =
format-warn = <ramp> <label-warn>
format-warn-underline =

label = TEMPERATURE %temperature-c%
label-warn = TEMPERATURE %temperature-c%
label-warn-foreground = ${colors.error}
label-foreground = ${colors.active}

ramp-0 = 
ramp-1 = 
ramp-2 = 
ramp-3 = 
ramp-4 = 
ramp-foreground = ${colors.active}

[module/powermenu]
type = custom/menu

expand-right = true

format-spacing = 1

label-open = 
label-open-foreground = ${colors.error}
label-open-padding = 1
label-close = ﰸ
label-close-foreground = ${colors.highlight}

menu-0-0 = 
menu-0-0-exec = menu-open-1
menu-0-1 = ⏼
menu-0-1-exec = menu-open-2
menu-0-0-margin-right = 1
menu-0-1-margin-right = 1

menu-1-0 = 
menu-1-0-exec = reboot
menu-1-1 = 
menu-1-1-exec = menu-open-0
menu-1-0-margin-right = 1
menu-1-1-margin-right = 1

menu-2-0 = 
menu-2-0-exec = menu-open-0
menu-2-1 = ⏼
menu-2-1-exec = poweroff
menu-2-0-margin-right = 1
menu-2-1-margin-right = 1

# }}}

# #########################################
# WINDOW MANAGER -------------------------- {{{
; [module/bspwm]
; type = internal/bspwm
;
; ws-icon-0 = term;
; ws-icon-1 = browser;
; ws-icon-2 = img;
; ws-icon-3 = file;
; ws-icon-4 = pomo;
; ws-icon-5 = games:
; ws-icon-default = 
;
; label-focused = %icon%
; label-focused-background = #505054
; label-focused-padding = 3
;
; label-occupied-background = #38383c
; label-occupied = %icon%
; label-occupied-padding = 3
;
; label-urgent = %icon%
; label-urgent-background = ${colors.error}
; label-urgent-padding = 3
;
; label-empty = %icon%
; label-empty-foreground = ${colors.foreground}
; label-empty-padding = 3

[module/i3]
type = internal/i3
format = <label-state><label-mode>
index-sort = true
enable-click = false
enable-scroll = false
content-padding = 1

ws-icon-0 = 1;
ws-icon-1 = 2;
ws-icon-2 = 3;
ws-icon-3 = 4;
ws-icon-4 = 5;
ws-icon-5 = 6;
ws-icon-6 = 7;
ws-icon-7 = 8;
ws-icon-8 = 9;
ws-icon-default = I

; Only show workspaces on the same output as the bar
pin-workspaces = true

; can use %name%, %index%
label-mode = %index%
label-mode-padding = 0
label-mode-foreground = ${colors.inactive}
label-mode-background = ${colors.background}

; focused = Active workspace on focused monitor
label-focused = "  "
label-focused-font = 3
label-focused-background =
label-focused-foreground = ${colors.active}
label-focused-underline =
label-focused-padding = 0

; unfocused = Inactive workspace on any monitor
; label-unfocused =
label-unfocused = "  "
label-unfocused-font = 3
label-unfocused-padding = 0
label-unfocused-foreground = ${colors.inactive}
label-unfocused-underline =

; visible = Active workspace on unfocused monitor
label-visible =
label-visible-font = 3
label-visible-background = ${colors.inactive}
label-visible-underline = ${colors.error}
label-visible-padding = 2

; urgent = Workspace with urgency hint set
label-urgent = "  "
label-urgent-font = 3
label-urgent-foreground= ${colors.error}
label-urgent-padding = 0
# }}}

# #########################################
# MULTIMEDIA ------------------------------ {{{
; [module/mpd]
; type = internal/mpd
; interval = 2
; label-song = " %{F#00cd00}%{F-} %artist% - %title% "
;
; label-song-maxlen = 100
; label-song-ellipsis = true
; label-font= 1
;
; host = 127.0.0.1
; port = 6600
;
; icon-seekb = 
; icon-seekf = 
; icon-stop = 
; icon-play = 
; icon-pause = 
; icon-prev = 
; icon-next = 
;
; icon-random = 
; icon-repeat = 
;
; toggle-on-foreground = ${colors.secondary}
; toggle-off-foreground = #66
;
; ; format-online = " <label-song> <icon-prev> <icon-seekb> <icon-stop> <toggle> <icon-seekf> <icon-next>  <icon-repeat> <icon-random> "
; format-online = " <label-song> "
; format-online-foreground = ${colors.orange}
;
; label-offline = 🎜  mpd is offline
; format-offline = " <label-offline> "
; format-offline-foreground = ${colors.background}


[module/mpd2]
type = internal/mpd
interval = 1
label =  <label-song> <icon-[random|repeat|repeatone]> <bar-progress>

host = 127.0.0.1
port = 6600

format-online = <icon-prev> <icon-seekb> <icon-stop> <toggle> <icon-seekf> <icon-next>   <label-time> <label-song> <bar-progress>
;format-offline =   Off
format-offline = MPD Off
label-song = %{F#00cd00}%{F-} %artist% - %title%

; Awesome Font >                   
icon-play = 
icon-pause = 
icon-stop = 
icon-prev = 
icon-next = 
icon-seekb = 
icon-seekf = 
icon-random = 
icon-repeat = 
icon-repeatone =

bar-progress-width = 20
bar-progress-indicator = |
bar-progress-fill = 
bar-progress-empty = 

; [module/alsa]
; type = internal/alsa
;
; format-volume = <label-volume> <bar-volume>
; label-volume = 
; label-volume-font = 3
; label-volume-foreground = ${colors.active}
;
; format-muted-prefix = " "
; format-muted-foreground = ${colors.error}
; label-muted = sound muted
;
; bar-volume-width = 10
; bar-volume-foreground-0 = #55aa55
; bar-volume-foreground-1 = #55aa55
; bar-volume-foreground-2 = #55aa55
; bar-volume-foreground-3 = #55aa55
; bar-volume-foreground-4 = #55aa55
; bar-volume-foreground-5 = #f5a70a
; bar-volume-foreground-6 = #ff5555
; bar-volume-gradient = false
; bar-volume-indicator = |
; bar-volume-indicator-font = 2
; bar-volume-fill = ─
; bar-volume-fill-font = 2
; bar-volume-empty = ─
; bar-volume-empty-font = 2
; bar-volume-empty-foreground = ${colors.active}

[module/alsa]
type = internal/alsa

format-volume = <label-volume>
label-volume =  %percentage%%

; ramp-volume-0 = 🔈
; ramp-volume-1 = 🔉
; ramp-volume-2 = 🔊

label-volume-foreground = ${colors.active}

format-muted-foreground = ${colors.error}
label-muted = 婢 muted
# }}}

# #########################################
# INTERNET -------------------------------- {{{
[module/eth]
type = internal/network
interface = enp0s31f6
interval = 3.0

format-connected-underline =
format-connected-prefix = " "
format-connected-prefix-font = 3
format-connected-prefix-foreground = ${colors.error}
label-connected = %local_ip%
label-connected-foreground = ${colors.foreground}

format-disconnected =

# }}}

# #########################################
# TIME ------------------------------------ {{{
; [module/date]
; type = internal/date
; interval = 5
;
; date = %d.%m.%y
; time = %H:%M
; time-alt = %H:%M:%S
;
; label = " %time% "
; format-prefix = " "
; format-prefix-foreground = ${colors.secondary}


[module/date]
type = internal/date
interval = 5

date = " %A, %d %B"

format-padding = 1
format-background = ${colors.background}
format-foreground = ${colors.foreground}

label = %date%

[module/time]
type = internal/date
interval = 5

time = " %I:%M %p"

format-padding = 1
format-background = ${colors.background}
format-foreground = ${colors.foreground}

label = %time%
# }}}

# #########################################
# MISC ------------------------------------ {{{
; [module/battery]
; type = internal/battery
; battery = BAT0
; adapter = ADP1
; full-at = 98
;
; format-charging = <animerahon-charging> <label-charging>
; format-charging-underline = #ffb52a
;
; format-discharging = <ramp-capacity> <label-discharging>
; format-discharging-underline = ${self.format-charging-underline}
;
; format-full-prefix = " "
; format-full-prefix-foreground = ${colors.foreground}
; format-full-underline = ${self.format-charging-underline}
;
; ramp-capacity-0 = 
; ramp-capacity-1 = 
; ramp-capacity-2 = 
; ramp-capacity-foreground = ${colors.foreground}
;
; animerahon-charging-0 = 
; animerahon-charging-1 = 
; animerahon-charging-2 = 
; animerahon-charging-foreground = ${colors.foreground}
; animerahon-charging-framerate = 750

# }}}

# #########################################
# CUSTOM SCRIPT --------------------------- {{{
# ------------------------
; [module/mydate]
; type = custom/script
; interval = 60
; exec = ~/.config/polybar/cal.sh
; ; format-prefix = "📅 "
; format-prefix = " "
; format-prefix-foreground = ${colors.active}
; format-prefix-font = 3
; format-foreground = ${colors.foreground}
; format-background =

[module/pomo]
type = custom/script
interval = 1
exec = ~/.local/bin/pomo status
label = "%output:0:20%"
format-padding = 1

[module/lockme]
type = custom/text
format = "<label>"
content = ""
label = " %output%"
content-padding = 1
content-foreground = ${colors.active}
content-font = 3
click-left = ~/.config/i3/lockme

[module/updates]
type = custom/script
interval = 1800
exec = ~/.config/polybar/checkupdates.sh
; format = "<label>"
format-prefix = " "
format-prefix-foreground = ${colors.highlight}
format-padding = 1

[module/todo]
type = custom/script
exec = ~/moxconf/exbin/for-local-bin/callcalcurse
format = "<label>"
format-prefix = " "
format-prefix-foreground = ${colors.active}
interval = 120

; [module/bitcoin]
; type = custom/script
; exec = curl -s https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCUSD | python -c "import json, sys; print(json.load(sys.stdin)['last'])"
; interval = 60.0
; format-background = ${colors.active}
; label = "$%output:0:10%"
; format-padding = 1

; [module/firefox]
; type = custom/text
; content = 
; content-foreground = ${colors.active}
; content-padding = 1
; click-left = firefox

; [module/nautilus]
; type = custom/text
; content = 
; content-foreground = ${colors.active}
; content-padding = 1
; click-left = Thunar
; click-left = Thunar; i3-msg floating enable

[module/appmenu]
type = custom/text
content = 
content-background = ${colors.active}
content-padding = 1

click-left = rofi -show window
click-middle = rofi -show ssh
click-right = rofi -show drun
# }}}

# #########################################
# SEPARATOR ------------------------------- {{{
# ------------------------
[module/arrow1]
type = custom/text
content = ""
content-foreground = ${colors.foreground}
content-background = ${colors.background}

[module/arrow2]
type = custom/text
content = ""
content-foreground = ${colors.background}
content-background = ${colors.foreground}

[module/RightArrow1]
type = custom/text
content = "  "
content-foreground = ${colors.foreground}
content-background = ${colors.background}

[module/MiddleArrowRight]
type = custom/text
content = ""
content-foreground = ${colors.background}
content-background = ${colors.foreground}

[module/rsp]
type = custom/text
content = 
content-foreground = ${colors.foreground}
content-background = ${colors.background}

[module/MiddleArrowLeft]
type = custom/text
content = ""
content-foreground = ${colors.foreground}
content-background = ${colors.background}
;◥ ◤◢ ◣

[module/separator2]
type = custom/text
content =|
content-foreground = #4C84C9
format-background = #26282B

# }}}
