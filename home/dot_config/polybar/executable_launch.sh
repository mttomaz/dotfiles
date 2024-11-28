#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Launch example bar
polybar example 2>&1 & disown

echo "Bars launched..."
