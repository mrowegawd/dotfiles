#!/bin/bash

# rofi_command="rofi -theme ~/.cache/wal/colors-rofi-dark-menu.rasi"

# shellcheck source=/dev/null
. "$HOME/Dropbox/exbin/for-local-bin/load-vars-rofi"

### Options ###
power_off=襤
reboot=ﰇ
lock=
suspend=鈴
log_out=
# Variable passed to rofi
options="$power_off\\n$reboot\\n$lock\\n$suspend\\n$log_out"

load_vars_rofi "powermenu"
themenya="$HOME/.config/rofi/onoff.rasi"

rofi_command="rofi -config $themenya -width $WIDTH \
  -lines 1 -eh 1 -width 100 -padding $(($(xwininfo -root \
  | awk '/Height/ { print $2}') / 2)) -opacity 20 -bw 0"

chosen="$(echo -e "$options" | $rofi_command -dmenu)"

case $chosen in
$power_off)
    sleep .5
    systemctl poweroff
    ;;
$reboot)
    sleep .5
    systemctl reboot
    ;;
$lock)
    sleep .5
    ~/.config/rofi/scripts/lock.sh
    ;;
$suspend)
    sleep .5
    ~/.config/rofi/scripts/lock.sh && systemctl suspend
    ;;
$log_out)
    killall sublime_text
    sleep .5
    i3-msg exit
    ;;
esac
