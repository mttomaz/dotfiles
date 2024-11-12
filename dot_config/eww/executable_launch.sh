#!/bin/sh

# EWW Path
CONFIG_PATH="$HOME/Documents/dev/eww"
EWW="eww -c $CONFIG_PATH"
NETWORK_INTERFACE="$(ip route | awk '/default/ {print $5}')"
export NETWORK_INTERFACE

if ! pidof eww; then
  ${EWW} daemon &
  sleep 0.25
  ${EWW} open bar
  if pidof bspwm; then
    sleep 0.25
    xdo lower -N "Eww"
    xdo above -N "Eww" -t "$(xdo id -N Bspwm -n root)"
  fi
else
  ${EWW} kill
fi
