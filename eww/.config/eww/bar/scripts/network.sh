#!/bin/sh
dvc="enp0s31f6" # change this to your device's name
net=$(iwctl station $dvc show)
ntnm=${net##*Connected network     } && ntnm=${ntnm%% *}
ntst=${net##*State                 } && ntst=${ntst%% *}

# count=0
disconnected="󰖪"
wireless_connected="󰖩"
# ethernet_connected="󰖩"
#
# ID="$(ip link | awk '/state UP/ {print $2}')"

case $1 in
"status")
	# [ "$ntst" = "connected" ] && ico="" || ico=""
	# echo "$ico"
  while true; do
      if (ping -c 1 archlinux.org || ping -c 1 google.com || ping -c 1 bitbucket.org || ping -c 1 github.com || ping -c 1 sourceforge.net) &>/dev/null; then
          echo "$wireless_connected" ; sleep 25
      else
          echo "$disconnected" ; sleep 0.5
      fi
  done
	;;
"network")
	[ "$ntst" = "connected" ] || ntnm="No connection"
	echo "$ntnm"
	;;
"toggle")
	[ -z "$ntst" ] && pwr="on" || pwr="off"
	iwctl device "$dvc" set-property Powered "$pwr"
	;;
esac
