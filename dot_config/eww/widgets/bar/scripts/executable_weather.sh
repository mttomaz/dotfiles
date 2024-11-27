#!/bin/bash

declare -a weather
weather_report="$(curl -s "wttr.in/Curitiba?format=%c+%C+%h+%t+%f+%m+%p")"
# shellcheck disable=SC2048
for i in ${weather_report[*]}; do
  weather+=("$i")
done

echo "{
  \"cond\":          \"${weather[0]}\",
  \"text_cond\":     \"${weather[1]}\",
  \"humidity\":      \"${weather[2]}\",
  \"temp\":          \"${weather[3]}\",
  \"feels_like\":    \"${weather[4]}\",
  \"moon\":          \"${weather[5]}\",
  \"precipitation\": \"${weather[6]}\"
}"
