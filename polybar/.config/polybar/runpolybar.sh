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
		# ~/.config/polybar/shades/launch.sh
		# MONITOR=$m polybar --reload top &
		# MONITOR=$m polybar --reload bottom &
	done
else
	# polybar --reload top &

	polybar -q top -c "$dir/bar/newback/config" &
	# polybar -q top -c "$dir/bar/grayblocks/config" &
	# "$dir/bar/grayblocks/launch.sh"
	# polybar --reload bottom &
fi
