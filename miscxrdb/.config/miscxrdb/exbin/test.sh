#!/bin/bash

#shellcheck source=/dev/null
. ~/.config/miscxrdb/fzf/fzf.config

vim() {
	awk '/^[a-z]/ && last {print $1,$2,"\t\t",last} {last=""} /^" keymap/{last=$0}' ~/.config/vimlocal/mapping.vim |
		column -t -s $'\t' | rofi -dmenu -shorting-method fzf -p "$1"
}

vim "vim"
