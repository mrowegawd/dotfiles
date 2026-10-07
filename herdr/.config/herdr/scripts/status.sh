#!/usr/bin/env bash

mydate=$(
  date '+%A %d-%b-%Y' |
    sed \
      -e 's/Monday/Senin/' \
      -e 's/Tuesday/Selasa/' \
      -e 's/Wednesday/Rabu/' \
      -e 's/Thursday/Kamis/' \
      -e 's/Friday/Jumat/' \
      -e 's/Saturday/Sabtu/' \
      -e 's/Sunday/Minggu/'
)

echo " $mydate   $(date +%H:%M)  👨 $(whoami)"
