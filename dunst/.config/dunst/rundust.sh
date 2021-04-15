#!/bin/bash

set -e -u
set -o nounset

# Date Created: 31 Mar 2019
# Last Modified: 23 Nov 2019 (20:30:13)
# Summary:
# Author: Gitmox
# License:

# if exists remove pid dunst first
pidof dunst && killall dunst
dunst &
