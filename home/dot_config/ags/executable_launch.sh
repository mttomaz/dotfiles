#!/bin/bash

HYPRLAND_SOCKET="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

start() {
  gjs -m "$HOME/.config/ags/app" &
}

monitor_added() {
  # INFO: https://github.com/Aylur/astal/issues/296
  case "$1" in
    monitoradded*) pkill -x gjs && start ;;
  esac
}

if ! pgrep -x gjs 1>/dev/null; then
  start
else
  pkill -x gjs && start
fi

while read -r line; do
  monitor_added "$line"
done < <(socat -u UNIX-CONNECT:"$HYPRLAND_SOCKET" -)
