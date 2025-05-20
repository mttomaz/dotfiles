#!/bin/bash

HYPRLAND_SOCKET="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

start() {
  pkill -x dunst
  pkill -x gjs
  gjs -m "$HOME/.config/ags/app" &
}

monitor_added() {
  # INFO: https://github.com/Aylur/astal/issues/296
  case "$1" in
    monitoradded*) start ;;
  esac
}

start

while read -r line; do
  monitor_added "$line"
done < <(socat -u UNIX-CONNECT:"$HYPRLAND_SOCKET" -)
