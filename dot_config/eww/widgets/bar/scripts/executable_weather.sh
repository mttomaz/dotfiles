#!/bin/bash

declare -a weather
request="wttr.in/Curitiba?format=%c%7C%C%7C%h%7C%t%7C%f%7C%w%7C%m%7C%p"
while read -r i; do
  weather+=("$i")
done < <(curl -s "$request" | awk -F '|' '{for(i=1; i<=NF; i++) print $i}')

echo "{
  \"cond\":          \"${weather[0]}\",
  \"text_cond\":     \"${weather[1]}\",
  \"humidity\":      \"${weather[2]}\",
  \"temp\":          \"${weather[3]}\",
  \"feels_like\":    \"${weather[4]}\",
  \"wind\":          \"${weather[5]}\",
  \"moon\":          \"${weather[6]}\",
  \"precipitation\": \"${weather[7]}\"
}"
