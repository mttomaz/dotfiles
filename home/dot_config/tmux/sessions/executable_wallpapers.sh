#!/bin/sh

SESSION_PATH="$HOME/Pictures/wallpapers"

tmux new-session -ds "$1" -c "$SESSION_PATH" -n "term"

tmux new-window -t "$1":2 -n "authors" -c "$SESSION_PATH/authors"
tmux send-keys -t "$1":2 "clear && yazi" C-m
tmux select-window -t "$1":1
