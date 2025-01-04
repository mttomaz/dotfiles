#!/bin/sh

if [ ! -f "$1" ]; then
  echo "File doesn't exists." && exit 1
fi

VIDEO_CODEC="$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$1")"
AUDIO_CODEC="$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$1")"
FILE_SIZE="$(du -h "$1" | cut -f1)"

printf "%s\nVideo: %s\nAudio: %s\nFile size: %s\n\n" "$1" "$VIDEO_CODEC" "$AUDIO_CODEC" "$FILE_SIZE"
