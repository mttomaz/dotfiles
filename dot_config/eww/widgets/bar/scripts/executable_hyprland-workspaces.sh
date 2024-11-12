#!/bin/sh

spaces() {
  hyprctl workspaces | awk '/workspace ID/ {print $3}' | sort
}

workspace() {
  buf=""
  focused_workspace="$(hyprctl activeworkspace -j | jq '.id')"
  for ws in $(spaces); do
    if [ "$ws" = "$focused_workspace" ]; then
      class="focused"
      icon="$ws"
    else
      class="occupied"
      icon="󰝥"
    fi
    buf="${buf} (button :class \"workspaces_${class}\" :onclick \"hyprctl dispatch workspace ${ws}\" \"${icon}\")"
  done
  echo "(box :class \"workspaces\" :halign \"center\" :valign \"center\" :vexpand true :hexpand true ${buf})"
}

workspace
socat -u UNIX-CONNECT:"${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" - | while read -r _; do
  workspace
done
