#!/bin/bash

bspc rule -r "*"

xrdb ~/.Xresources &
sleep 2

~/Dropbox/exbin/for-local-bin/paintree

getcolors() {
  # BLACK=$(xrdb -query | grep 'color0:' | awk '{print $NF}')
  # GREEN=$(xrdb -query | grep 'color2:' | awk '{print $NF}')
  activate=$(xrdb -query | grep foreground | awk '{print $NF}')
  inactive=$(xrdb -query | grep background | cut -d':' -f2 | sed 's/ //g' | xargs)
  # MAGENTA=$(xrdb -query | grep 'color5:' | awk '{print $NF}')
}

getcolors
# Set the border colors.
bspc config normal_border_color "$inactive"
bspc config focused_border_color "$activate"
bspc config presel_feedback_color "$inactive"
# bspc config active_border_color "$MAGENTA"

# setxkbmap -layout us -variant intl

# switch capslock to backspace
setxkbmap -option caps:backspace

killall -q mpd
mpd &
killall -q compton
compton --config ~/.config/compton.conf &

~/.config/polybar/runpolybar.sh
~/.config/dunst/rundust.sh

# killall -q clipmenud
# clipmenud &

"$HOME/Dropbox/exbin/for-local-bin/fehbg"

export _JAVA_AWT_WM_NONREPARENTING=1

# reload config ~/.lesskey if exists
[[ -f ~/.lesskey ]] && lesskey
[[ -f ~/Dropbox/exbin/for-local-bin/fehbg ]] && ~/Dropbox/exbin/for-local-bin/fehbg
killall -q dropbox
[[ -f ~/Dropbox/exbin/for-local-bin/appbox ]] && ~/Dropbox/exbin/for-local-bin/appbox
