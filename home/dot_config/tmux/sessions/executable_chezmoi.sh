#!/bin/sh

SESSION_PATH="$HOME/.local/share/chezmoi"

tmux new-session -ds "$1" -c "$SESSION_PATH" -n "term"

tmux new-window -t "$1":2 -n "edit" -c "$SESSION_PATH"
tmux send-keys -t "$1":2 "clear && neo" C-m
tmux select-window -t "$1":1
