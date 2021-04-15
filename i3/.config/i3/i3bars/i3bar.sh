#!/usr/bin/env bash


##
## Generate JSON for i3bar
## A replacement for i3status written in bash
## kalterfive
##
## Dependencies:
## mpd, mpc, deadbeef
## skb -- get language
## sensors -- get heating cpu
## acpi -- get battery state
##
# vars colors -------------------------------- {{{
YELLOW='\033[33;33m'
NC='\033[0m' # No Color

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

BOLD=$(tput bold)
NORMAL=$(tput sgr0)
JEMPOL="\uf087"
# }}}

#	{{{ Error codes

E_UE=6 # unhandeled event

#	}}}


#	{{{ Colors

color_white='#FFFFFF'
color_green='#53F34C'

color_std='#CCCCCC'
color_waring='#BBBB00'
color_danger='#FB2020'

icon_color='"icon_color":"'$color_white'"'

#	}}}

# i3status | while :
SLEEP=1


while :; do
sleep ${SLEEP}

Between ()
{
  # echo -n " ^fg(#7298a9)^r(2x2)^fg() "
  echo -n " ${Green}| ${NC} "
  return
}

Whoami ()
{
  whome=$(whoami)
  echo -n " $whome"
  return
}

Print () {
  Whoami
  Between
  echo
  return
}
Print
done
