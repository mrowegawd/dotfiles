#!/bin/bash

set -e -u

if command -v dropbox &> /dev/null; then
  dropbox start
fi
