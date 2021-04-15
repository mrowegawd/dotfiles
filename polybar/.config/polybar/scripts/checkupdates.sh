#!/usr/bin/env bash

# get full lines info updates when you run this
# apt-get -s dist-upgrade | grep "^[[:digit:]]\+ upgraded"

# only grab updates
OUTPUT=$(apt-get -s dist-upgrade | grep -Po "^[[:digit:]]+ (?=upgraded)" | xargs)

if [ "$OUTPUT" == "0" ]; then
  echo "Up-to-date"
else
  echo "$OUTPUT"
fi
