#!/bin/sh

PRIMARY_MONITOR="$(xrandr | awk '/primary/ {print $1}')"

contains() {
  for i in $1; do
    [ "$i" = "$2" ] && true && return
  done
  false
}

workspace() {
  monitor="--monitor $1"
  buf=""
  desktops="$(bspc query -D --names $monitor)"
  focused_desktop="$(bspc query -D -d focused --names $monitor)"
  occupied_desktops="$(bspc query -D -d .occupied --names $monitor)"

  for ws in $desktops; do
    if contains "$focused_desktop" "$ws"; then
      class="focused"
      icon="$ws"
    elif contains "$occupied_desktops" "$ws"; then
      class="occupied"
      icon="󰝥"
    else
      class="empty"
      icon="󰝥"
    fi

    buf="${buf} (button :class \"workspaces_${class}\" :onclick \"bspc desktop -f ${ws}\" \"${icon}\")"
  done
  echo "(box :class \"workspaces\" :halign \"center\" :valign \"center\" :vexpand true :hexpand true ${buf})"
}

workspace "$PRIMARY_MONITOR"
bspc subscribe desktop_focus node_add node_remove node_transfer | while read -r _; do
  workspace "$PRIMARY_MONITOR"
done
