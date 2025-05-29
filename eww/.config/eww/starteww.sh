#!/bin/bash

killall eww
sleep 1
"$HOME/.local/bin/eww" daemon
"$HOME/.local/bin/eww" open bar
