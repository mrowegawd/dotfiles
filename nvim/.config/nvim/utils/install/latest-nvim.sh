#!/bin/bash

DOWNLOAD_PATH="$HOME/Downloads"

cd "$DOWNLOAD_PATH"
sudo rm -rf neovim
git clone https://github.com/neovim/neovim neovim
cd neovim
git checkout nightly
sudo make distclean CMAKE_BUILD_TYPE=Release install
echo $(pwd)
cd "$DOWNLOAD_PATH"
echo $(pwd)
sudo rm -r $DOWNLOAD_PATH/neovim
