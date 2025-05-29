#!/bin/bash

# Terminate already running bar instances

dir="$HOME/.config/polybar"
# themes=$(ls --hide="launch.sh" "$dir")

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# load monitor
if type "xrandr"; then
  for m in $(xrandr -q | grep -w "connected" | cut -d " " -f1); do
    MONITOR=$m polybar -q top -c "$dir/bar/newback/config" &
  done
else
  polybar -q top -c "$dir/bar/newback/config" &
fi
