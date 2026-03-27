#!/bin/sh

start_date="$(stat / | tail -n1 | awk -F': ' '{print $2}')"
diff_days=$(( ($(date +%s) - $(date -d "$start_date" +%s)) / 86400 ))
echo "$diff_days"
