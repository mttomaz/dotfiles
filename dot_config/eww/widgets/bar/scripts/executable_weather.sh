#!/bin/sh

curl -s "wttr.in/Curitiba?format=1" | awk '{print $2 " " $1}'
