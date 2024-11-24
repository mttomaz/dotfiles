#!/bin/sh

case "$1" in
output)
  ID="@DEFAULT_SINK@"
  ;;
spotify)
  ID="$(wpctl status | awk '/spotify/ {sub(/.$/,"",$1); print $1}' | tail -n1)"
  ;;
esac

case "$2" in
change)
  wpctl set-volume "$ID" "$3"
  ;;
set)
  wpctl set-volume "$ID" "$3"
  ;;
get)
  wpctl get-volume "$ID" | awk -F. '{print $2}'
  ;;
esac
