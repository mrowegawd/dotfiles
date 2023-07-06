#!/bin/bash

bspc rule -r "*"

xrdb ~/.Xresources &
sleep 2

[[ -f "$HOME/Dropbox/exbin/for-local-bin/paintree" ]] && "$HOME/Dropbox/exbin/for-local-bin/paintree"

getcolors() {
	# activate=$(xrdb -query | grep foreground | awk '{print $NF}')
	inactive=$(xrdb -query | grep background | cut -d':' -f2 | sed 's/ //g' | xargs)
	MAGENTA=$(xrdb -query | grep 'color5:' | awk '{print $NF}')
	# BLACK=$(xrdb -query | grep 'color0:' | awk '{print $NF}')
	GREEN=$(xrdb -query | grep 'foreground:' | awk '{print $NF}')
}

getcolors
# Set the border colors.
bspc config normal_border_color "$inactive"
bspc config focused_border_color "$GREEN"
bspc config active_border_color "$GREEN"
bspc config presel_feedback_color "$MAGENTA"

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

if [ ! -z "$(command -v clipmenud)" ]; then
	killall -q clipmenud
	clipmenud &
fi

[[ -f "$HOME/.config/polybar/runpolybar.sh" ]] && "$HOME/.config/polybar/runpolybar.sh"
[[ -f "$HOME/.config/dunst/rundust.sh" ]] && "$HOME/.config/dunst/rundust.sh"
[[ -f "$HOME/Dropbox/exbin/for-local-bin/fehbg" ]] && "$HOME/Dropbox/exbin/for-local-bin/fehbg"
[[ -f ~/.lesskey ]] && lesskey
[[ -f ~/Dropbox/exbin/for-local-bin/fehbg ]] && ~/Dropbox/exbin/for-local-bin/fehbg
if [[ -n $(command -v dropbox) ]]; then
	killall -q dropbox
	dropbox start &
fi
