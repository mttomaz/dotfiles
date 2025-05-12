#!/bin/sh

export SESSIONS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/sessions"
. "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/scripts/utils.sh"

get_session_list | fzf --prompt="Choose a session: " > /tmp/.tmux-popup-output
