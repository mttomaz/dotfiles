#!/bin/sh

wpctl status | awk '/Chromium/ && !/Chromium\s*input/ {gsub(/\./, ""); print $1}' | while read -r id; do
  wpctl set-mute "$id" toggle 2>/dev/null
done
