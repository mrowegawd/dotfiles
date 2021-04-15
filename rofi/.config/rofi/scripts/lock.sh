#!/bin/bash
ICON=$HOME/Dropbox/mytodo/icons/golang-drop-mic.png
TMPBG=/tmp/screen.png
scrot /tmp/screen.png
convert $TMPBG -blur 0x3 $TMPBG
convert "$TMPBG" "$ICON" -gravity center -composite -matte "$TMPBG"
i3lock -i "$TMPBG"
