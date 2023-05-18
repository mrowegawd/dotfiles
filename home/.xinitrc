!#/bin/sh
# -*- coding: utf-8 -*-

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# exec awesome

# xrdb ~/.Xresources

# wal --iterative --theme base16-ocean

# compton &

# urxvtd -q -o -f &

# setxkbmap us -variant colemak
setxkbmap -option caps:backspace
