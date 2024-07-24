#!/bin/sh

xrdb ~/.Xresources &
sleep 2

pantree="$HOME/.config/miscxrdb/exbin/paintree"
[ -f "$pantree" ] && "$pantree"

# setxkbmap -layout us -variant intl
setxkbmap -option caps:backspace # switch capslock to backspace
export _JAVA_AWT_WM_NONREPARENTING=1

# if [ -f "$HOME/.config/compton.conf" ]; then
# 	if [ ! -z "$(command -v compton)" ]; then
# 		killall -q compton
# 		compton --config ~/.config/compton.conf &
# 	fi
# fi

# if [ -f "$HOME/.config/picom.conf" ]; then
#   if [ ! -z "$(command -v picom)" ]; then
#     killall -q picom
#     picom --experimental-backend --config ~/.config/picom.conf &
#   fi
# fi

if [ -n "$(command -v clipmenud)" ]; then
  killall -q clipmenud
  clipmenud &
fi

[ -f "$HOME/.config/polybar/runpolybar.sh" ] && "$HOME/.config/polybar/runpolybar.sh"
[ -f "$HOME/.config/dunst/rundust.sh" ] && "$HOME/.config/dunst/rundust.sh"
[ -f ~/.lesskey ] && lesskey
[ -f "$HOME/.config/miscxrdb/exbin/fehbg" ] && "$HOME/.config/miscxrdb/exbin/fehbg"

# Use `sync-update` to run dropbox
if [ -n "$(command -v dropbox)" ]; then
  killall -q dropbox
  dropbox start &
fi
