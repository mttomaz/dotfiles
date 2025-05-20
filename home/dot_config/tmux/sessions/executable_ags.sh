#!/bin/sh

SESSION_PATH="$HOME/.config/ags"

tmux new-session -ds "$1" -c "$SESSION_PATH" -n "edit"

tmux new-window -t "$1":2 -n "gjs" -c "$SESSION_PATH"
pgrep -x gjs || tmux send-keys -t "$1":2 "./launch.sh" C-m
tmux new-window -t "$1":3 -n "other" -c "$SESSION_PATH"
tmux select-window -t "$1":1
