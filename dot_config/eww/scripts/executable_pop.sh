#!/bin/bash

# EWW Path
CONFIG_PATH="$HOME/Documents/dev/eww"
EWW="eww -c $CONFIG_PATH"
mapfile -t WINDOWS <<<"$(${EWW} active-windows | awk -F: '!/^bar/ {print $1}')"

close_windows() {
  for window in "${WINDOWS[@]}"; do
    if [[ "$window" != "$1" ]]; then
      if [[ "$window" =~ ${WINDOWS[*]} ]]; then
        ${EWW} close "${window}"
      fi
    fi
  done
}

if ! grep -q "$1" <<<"${WINDOWS[@]}"; then
  [[ -n "${WINDOWS[*]}" ]] && close_windows "$1"
  ${EWW} open "$1"
else
  ${EWW} close "$1"
fi
