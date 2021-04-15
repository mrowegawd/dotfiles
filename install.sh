#!/bin/bash


mkdir -p ~/.local/bin
mkdir -p ~/.local/share/fonts
mkdir -p ~/.local/share/gem
mkdir -p ~/.local/share/nvim
mkdir -p ~/.local/share/virtualenv
mkdir -p ~/.local/share/virtualenvs

mkdir -p ~/.cache

mkdir -p ~/.newsboat

mkdir -p ~/.tmux/plugins
mkdir -p ~/.tmux/resurrect
mkdir -p ~/.tmux/scripts
mkdir -p ~/.tmux/themes

mkdir -p ~/.w3m

for d in */ ; do
  if [ "$d" == "img/" ]; then
    continue
  fi

  stow --adopt -vt ~ "$d"

done

echo "Check your linking"
