#!/bin/sh

get_session_list() {
  active_sessions="$(tmux list-sessions -F '#S' 2>/dev/null || true)"
  predefined_sessions="$(basename -s .sh "$SESSIONS_DIR"/*.sh 2>/dev/null || true)"
  all_sessions=$(printf "%s\n%s\n" "$active_sessions" "$predefined_sessions" | sort -u)

  for session in $all_sessions; do
    if echo "$active_sessions" | grep -qx "$session"; then
      echo "[●] $session"
    else
      echo "[ ] $session"
    fi
  done
}

extract_session_name() {
  echo "$1" | sed 's/^\[[^]]*\] //'
}
