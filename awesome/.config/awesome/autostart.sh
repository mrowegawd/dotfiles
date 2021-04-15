#!/bin/bash

xrdb ~/.Xresources
xrdb -merge ~/.Xresources

~/moxconf/exbin/for-local-bin/paintree

# setxkbmap -layout us -variant intl

# switch capslock to backspace
setxkbmap -option caps:backspace

killall -q compton mpd
mpd &
compton --config ~/.config/compton.conf &

# ~/.config/polybar/launch_polybar
# ~/moxconf/exbin/for-local-bin/wal
# ~/.config/dunst/rundust
~/.config/rofi/reset-rofi

[[ -f ~/.lesskey ]] && lesskey      # load lesskey
# [[ -f ~/.fehbg ]] && ~/.fehbg

# killall -q dropbox; ~/moxconf/exbin/for-local-bin/appbox
