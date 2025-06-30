#!/bin/bash

# INFO: most things installed with the scripts in home/.chezmoiscripts
# are for my personal use, feel free to comment things you dont want to install.
# I have a AMD GPU, so if you use Nvidia you have to
# configure and install more things (specially on wayland).

if command -v pacman >/dev/null; then
  sudo pacman -Syyu --needed chezmoi bitwarden-cli
fi

if ! bw login --check >/dev/null; then
  BW_SESSION="$(bw login "mttomaz@duck.com" --raw)"
else
  BW_SESSION="$(bw unlock --raw)"
fi
export BW_SESSION

echo -e "\n\033[1;32mInitialing chezmoi ...\033[0m"
chezmoi init --apply mttomaz
