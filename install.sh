#!/bin/bash

# INFO: most things installed here are for my personal use,
# feel free to comment things you dont want to install.
# I have a AMD GPU, so if you use Nvidia you have to
# configure and install more things (specially on wayland).

# Colors
END="\033[0m"
RED="\033[0;31m"
GREEN="\033[1;32m"

info() {
  echo -e "\n${GREEN}${1}${END}"
}

error() {
  echo -e "\n${RED}${1}${END}"
  exit 1
}

info "Select a WM/Compositor ..."
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


# Installing packages, if you are on void or arch
info "Installing packages ..."
# TODO: add all necessary packages
if command -v xbps-install &>/dev/null; then
  sudo xbps-install -Su git gawk dex mesa-vulkan-radeon nodejs gcc chezmoi rofi rofi-emoji zsh-{autosuggestions,syntax-highlighting} starship neovim yazi btop fzf ripgrep papirus-icon-theme brightnessctl font-fira-ttf socat jq flatpak
  sudo ln -s /etc/sv/{dbus,polkit} /var/service/
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  if [ "$WM" = "bspwm" ]; then
    sudo xbps-install xf86-video-amdgpu bspwm sxhkd sx xorg-minimal xdo xdotool xrandr xkill xset xsetroot redshift elogind polkit
    echo -e "#!/bin/sh\npreg -x bspwm || exec dbus-run-session sx" >"$HOME/.config/zsh/session.sh"
  elif [ "$WM" = "hyprland" ]; then
    echo "repository=https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc" | sudo tee /etc/xbps.d/hyprland-void.conf
    sudo xbps-install -S hyprland xdg-desktop-portal-hyprland foot swaybg wl-clipboard wlsunset
    echo -e "#!/bin/sh\nexec dbus-run-session Hyprland" >"$HOME/.config/zsh/session.sh"
  fi

elif command -v pacman &>/dev/null; then
  sudo pacman -Syu git awk dex mesa npm gcc chezmoi rofi-wayland rofi-emoji zsh-{autosuggestions,syntax-highlighting} starship neovim yazi btop fzf ripgrep papirus-icon-theme brightnessctl ttf-fira-sans curl wget socat jq flatpak
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  if [ "$WM" = "bspwm" ]; then
    sudo pacman -S xf86-video-amdgpu bspwm sxhkd sx xorg-server xdo xdotool xorg-xrandr xorg-xkill xorg-xset xorg-xsetroot redshift xorg-xclip
    echo -e "#!/bin/sh\npreg -x bspwm || exec sx" >"$HOME/.config/zsh/session.sh"
  elif [ "$WM" = "hyprland" ]; then
    sudo pacman -S hyprland xdg-desktop-portal-hyprland foot swaybg wl-clipboard wlsunset
    echo -e "#!/bin/sh\nexec Hyprland" >"$HOME/.config/zsh/session.sh"
  fi
else
  error "Could not find xbps-install or pacman, no package was installed."
fi

# Creating directories needed for applications and scripts (and my personal use)
info "Creating directories ..."
mkdir -p "$HOME"/.local/{share,state} "$HOME"/.cache/{zsh,scripts}
mkdir -p "$HOME"/{Documents/{dev,github},Downloads,Pictures/screenshots}

# Setting ZDOTDIR
if [ -z "$ZDOTDIR" ]; then
  info "Setting \$ZDOTDIR ..."
  echo "ZDOTDIR=\"\$HOME/.config/zsh\"" | sudo tee -a /etc/zsh/zshenv
fi

# Initializing and applying dotfiles
info "Initialing chezmoi ..."
chezmoi init --apply MatheusTT

# Installing rust via rustup (needed for eww)
info "Installing rust ..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs >/tmp/rustup.sh
sh /tmp/rustup.sh --default-toolchain nightly --no-modify-path
source "$HOME/.local/share/cargo/env"

# TODO: how could i automate the install of flutter?

# Compiling eww
info "Installing eww ..."
git clone https://github.com/elkowar/eww "$HOME/Documents/github/eww"
cd "$HOME/Documents/github/eww" || error "Could not change dir to ~/Documents/github/eww"
cargo build --release --no-default-features
cp target/release/eww ~/.local/bin/eww

# Regenerating font cache
info "Regenerating font cache ..."
fc-cache -frv

# Installing spicetify and changing default dir to ~/.local/share/spicetify
info "Installing spicetify ..."
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh >/tmp/spicetify.sh
sed 's/\.spicetify/\.local\/share\/spicetify/' /tmp/spicetify.sh | sh

# Installing Zen Browser, the new "Arc like" browser based on firefox
info "Installing Zen Browser ..."
cd "$HOME/Downloads/" || error "Could not change dir to ~/Downloads/"
wget https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.bz2
tar xvf zen.linux-x86_64.tar.bz2
mv zen ~/.local/share/zen
ln -s ~/.local/share/zen/zen ~/.local/bin/zen

# Downloading my wallpapers, theres a script named "random-wallpaper" that sets my wallpaper
info "Donwloading my collection of wallpapers ..."
git clone https://github.com/MatheusTT/wallpapers "$HOME/Pictures/wallpapers"
