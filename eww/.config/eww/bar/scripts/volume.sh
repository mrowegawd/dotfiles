#!/bin/sh

# sftc=$(amixer sget Master)
# mftc=$(amixer sget Capture)
#
# case $1 in
# "sysvol")
# 	svol=${sftc#*[} && vol=${vol%%%*}
# 	echo "$svol"
# 	;;
# "sysmute")
# 	stt=${sftc#*] [} && stt=${stt%%]*}
# 	[ "$stt" = "off" ] && icon="" || icon=""
# 	echo "$icon"
# 	;;
# "micvol")
# 	vol=${mftc#*[} && vol=${vol%%%*}
# 	echo "$vol"
# 	;;
# "micmute")
# 	stt=${mftc#*] [} && stt=${stt%%]*}
# 	[ "$stt" = "off" ] && icon="" || icon=""
# 	echo "$icon"
# 	;;
# "musvol")
# 	vol=$(playerctl volume)
# 	vol=${vol%0000*}
# 	[ "$vol" = "1.00" ] && vol=100 || vol=${vol##*.}
# 	echo "$vol"
# 	;;
# esac

#!/bin/bash

# amixer --get-volume-human | tr -d '%'

# pactl subscribe | rg --line-buffered "on sink" | while read -r _; do
# 	pamixer --get-volume-human | tr -d '%'
# done
# pamixer --get-volume

# volume=$(pamixer --get-volume)
# echo "$volume asdfsaf"

pamixer --get-volume-human | tr -d '%'

pactl subscribe | rg --line-buffered "on sink" | while read -r _; do
  pamixer --get-volume-human | tr -d '%'
done
