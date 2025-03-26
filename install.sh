#!/bin/bash

# INFO: most things installed here are for my personal use,
# feel free to comment things you dont want to install.
# I have a AMD GPU, so if you use Nvidia you have to
# configure and install more things (specially on wayland).

# Colors
END="\033[0m"
RED="\033[0;31m"
GREEN="\033[1;32m"

info_msg() {
  echo -e "\n${GREEN}${1}${END}"
}

error_msg() {
  echo -e "\n${RED}${1}${END}"
  exit 1
}

info_msg "Select a WM/Compositor ..."
select opt in "bspwm" "hyprland" "none"; do
  case "$opt" in
    bspwm)
      WM="bspwm"
      break;;
    hyprland)
      WM="hyprland"
      break;;
    none)
      WM="none"
      break;;
    *)
      echo "Please select a WM/Compositor..."
      ;;
  esac
done

PKGS=(
  mesa
  lazygit
  dex
  gcc
  chezmoi
  rofi-emoji
  zsh-autosuggestions
  zsh-syntax-highlighting
  starship
  neovim
  yazi
  btop
  fzf
  ripgrep
  papirus-icon-theme
  brightnessctl
  curl
  wget
  socat
  jq
  flatpak
  zathura-pdf-poppler
  lsd
  tmux
  trash-cli
  imv
  mpv
  dunst
  wireplumber
  sof-firmware
  pulsemixer
  opendoas
  rustup
  meson
  ninja
  tealdeer
)

# Installing packages, if you are on void or arch
info_msg "Installing packages ..."
# TODO: add all necessary packages
if command -v xbps-install &>/dev/null; then
  sudo xbps-install -Su "${PKGS[@]}" dbus elogind polkit gawk nodejs rofi font-fira-ttf alsa-pipewire libjack-pipewire pcmanfm
  sudo ln -s /etc/sv/{dbus,polkit} /var/service/
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  if [ "$WM" = "bspwm" ]; then
    sudo xbps-install xf86-video-amdgpu bspwm sxhkd sx xorg-minimal xdo xdotool xrandr xkill xset xsetroot redshift setxkbmap
    echo -e "#!/bin/sh\npgreg -x bspwm || exec dbus-run-session sx" >"$HOME/.config/zsh/session.sh"
  elif [ "$WM" = "hyprland" ]; then
    echo "repository=https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc" | sudo tee /etc/xbps.d/hyprland-void.conf
    sudo xbps-install -S hyprland xdg-desktop-portal-hyprland foot swaybg wl-clipboard wlsunset
    echo -e "#!/bin/sh\nexec dbus-run-session Hyprland" >"$HOME/.config/zsh/session.sh"
  fi

elif command -v pacman &>/dev/null; then
  sudo pacman -Syu "${PKGS[@]}" awk npm rofi-wayland ttf-fira-sans pipewire-{alsa,audio,jack,pulse} pcmanfm-gtk3
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  if [ "$WM" = "bspwm" ]; then
    sudo pacman -S xf86-video-amdgpu bspwm sxhkd sx xorg-server xdo xdotool xorg-xrandr xorg-xkill xorg-xset xorg-xsetroot redshift xorg-xclip xorg-setxkbmap
    echo -e "#!/bin/sh\npgreg -x bspwm || exec sx" >"$HOME/.config/zsh/session.sh"
  elif [ "$WM" = "hyprland" ]; then
    sudo pacman -S hyprland xdg-desktop-portal-hyprland foot swaybg wl-clipboard hyprsunset
    echo -e "#!/bin/sh\nexec Hyprland" >"$HOME/.config/zsh/session.sh"
  fi
else
  error_msg "Could not find xbps-install or pacman, no package was installed."
fi

# Creating directories needed for applications and scripts (and my personal use)
info_msg "Creating directories ..."
mkdir -p "$HOME"/.local/{share,state} "$HOME"/.cache/{zsh,scripts}
mkdir -p "$HOME"/{Documents/{dev,github},Downloads,Pictures/screenshots}

# Changing shell to ZSH
if [ "$(echo "$SHELL" | awk -F/ '{print $NF}')" != "zsh" ]; then
  info_msg "Changing shell to ZSH ..."
  chsh -s /usr/bin/zsh
fi

# Setting ZDOTDIR
if [ -z "$ZDOTDIR" ]; then
  info_msg "Setting \$ZDOTDIR ..."
  echo "ZDOTDIR=\"\$HOME/.config/zsh\"" | sudo tee -a /etc/zsh/zshenv
fi

# Initializing and applying dotfiles
info_msg "Initialing chezmoi ..."
chezmoi init --apply MatheusTT

# Regenerating font cache
info_msg "Regenerating font cache ..."
fc-cache -frv

# Setting themes using gsettings
info_msg "Setting themes using gsettings ..."
gsettings set org.gnome.desktop.interface gtk-theme "Kanagawa-B-LB"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
gsettings set org.gnome.desktop.interface cursor-theme "cz-Hickson-Black"

# Installing rust via rustup (needed for eww)
info_msg "Installing rust ..."
rustup toolchain install nightly
rustup default nightly

# TODO: automate flutter installation

# Compiling eww
info_msg "Installing eww ..."
git clone https://github.com/elkowar/eww "$HOME/Documents/github/eww"
cd "$HOME/Documents/github/eww" || error_msg "Could not change dir to ~/Documents/github/eww"
cargo build --release --no-default-features
cp target/release/eww ~/.local/bin/eww

# Installing Zen Browser, the new "Arc like" browser based on firefox
info_msg "Installing Zen Browser ..."
cd "$HOME/Downloads/" || error_msg "Could not change dir to ~/Downloads/"
wget https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz
tar xvf zen.linux-x86_64.tar.xz
mv zen ~/.local/share/zen
ln -s ~/.local/share/zen/zen ~/.local/bin/zen

# Installing my fork of playerctl
info_msg "Installing my fork of playerctl ..."
git clone https://github.com/MatheusTT/playerctl "$HOME/Documents/github/playerctl"
cd "$HOME/Documents/github/playerctl" || error_msg "Could not change dir to ~/Documents/github/playerctl"
meson mesonbuild
sudo ninja -C mesonbuild install

# Downloading my wallpapers, theres a script named "random-wallpaper" that sets my wallpaper
info_msg "Donwloading my collection of wallpapers ..."
git clone https://github.com/MatheusTT/wallpapers "$HOME/Pictures/wallpapers"
