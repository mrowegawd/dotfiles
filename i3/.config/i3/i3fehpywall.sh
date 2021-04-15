#!/bin/bash


set -u -e

USER=$(whoami)

# i3WALLPATH="$HOME/.config/i3/walli3"
i3WALLPATH="/media/$USER/projectid/programming/walli3/"



if [ -d "$i3WALLPATH" ]; then
  wallpaperI3="$(find "$i3WALLPATH"/* -type f -name '*.jpg' | sort -R | head -1)"
  # feh --bg-center "$wallpaperI3"
  "$HOME"/.local/bin/wal -i "$wallpaperI3"
fi
