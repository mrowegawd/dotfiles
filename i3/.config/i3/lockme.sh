#!/bin/bash

kitty -e cmatrix -C blue &

sleep 1

i3-msg fullscreen

i3lock -u -n; i3-msg kill
