#!/bin/bash
[[ -z $(command -v nvim) ]] && dunstify "Command not found" " af" && exit 1

ICON=$HOME/Dropbox/neorg/img/golang-gopher-drop-mic.png
rm /tmp/screen_img*
TMPBG=/tmp/screen_img.png
scrot /tmp/screen_img.png
convert $TMPBG -blur 0x3 $TMPBG
# convert "$ICON" -resize 800x800 "$ICON"
convert "$TMPBG" "$ICON" -gravity center -composite -matte "$TMPBG"

# i3lock -i "$TMPBG"
betterlockscreen -u $TMPBG
betterlockscreen -l
# betterlockscreen -l blur
