#!/bin/sh
# This is super specific to my own use case, feel free to edit it or remove it. The "language" bar widget does call it so consider repurposing that as well.

case $1 in
"launcher")
	sh "$HOME/.config/miscxrdb/bin/appmenu"
	;;
"lang")
	lang=$(setxkbmap -query)
	lang=${lang##* }
	[ "$lang" = "us" ] && kb="latam" || kb="us"
	[ "$lang" = "us" ] && name="Latinamerican Spanish" || name="American English"
	setxkbmap "$kb"
	dunstify -h string:x-dunst-stack-tag:lang "Keyboard Layout" "Set to $name"
	;;
"month")
	a=$(date -u '+%m')
	echo $((a - 1))
	;;
esac
