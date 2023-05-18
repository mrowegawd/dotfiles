#!/bin/bash

set -e

dir="$HOME/.config/rofi/menu"
theme="styles/menuleft"
rofi_command="rofi -theme $dir/$theme"

options="@\nBookmarks\nEmail\nEmojis\nEarnings\nGames\nGhosted\nGuide linux\nSnippet\nThemes\nTools\nRasp-on"

chosen="$(echo -e "$options" | $rofi_command -p "  " -dmenu -i)"

(
	[[ -z $chosen ]] && exit

	MYBIN_PATH="$HOME/Dropbox/exbin"
	[[ ! -d $MYBIN_PATH ]] && dunstify "Path not found:" "$MYBIN_PATH"

	case "$chosen" in
	"@")
		rofi -theme "$dir/$theme" -show drun
		;;
	"Bookmarks") "$dir/_bookmarks" ;;
	"Emojis") "$dir/_emoji" ;;
	"Email") "$MYBIN_PATH/for-local-bin/muttmail" ;;
	"Guide linux") "$dir/_glinux" ;;
	"Snippet") "$dir/_snippet" ;;
	"Themes") "$dir/_themes" ;;
	"Tools") "$dir/_tools" ;;
	esac
)
