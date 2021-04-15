#!/usr/bin/env bash

set -e -u
$1 --version |  perl -pe '($_)=/([0-9]+([.][0-9]+)+)/'
