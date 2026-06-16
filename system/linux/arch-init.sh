#!/bin/bash

# init arch

log_packages() {
  echo
  echo "log installed packages"

  echo
  echo "pacman -Q | sudo tee /root/pkgs-$(date +%Y-%m-%d-%H-%M).txt > /dev/null"
  pacman -Q | sudo tee "/root/pkgs-$(date +%Y-%m-%d-%H-%M).txt" > /dev/null

  echo
  echo "pacman -Q | wc -l"
  pacman -Q | wc -l
}

install_packages() {
  local packages=("$@")
  echo "${packages[@]}"
  sudo pacman -S --needed --noconfirm "${packages[@]}"
}

main() {
  log_packages

  sudo pacman -Syu --noconfirm

  install_packages base-devel linux-headers

  install_packages openssh tmux vim
  install_packages bash bash-completion
  install_packages zsh zsh-completions
  install_packages zsh-autosuggestions zsh-syntax-highlighting zsh-lovers
  install_packages curl git rsync
  install_packages man-db man-pages
  install_packages zip unzip p7zip

  install_packages htop fzf fd ripgrep
  install_packages yazi

  if false; then
    echo
    echo "install GUI"
    install_packages noto-fonts noto-fonts-cjk noto-fonts-emoji
    install_packages ttf-sarasa-gothic ttf-firacode-nerd

    install_packages gnome gnome-tweaks gnome-themes-extra
    install_packages gnome-shell-extension-appindicator
    install_packages gnome-shell-extension-dash-to-panel
    install_packages ibus ibus-libpinyin

    install_packages firefox chromium vlc timeshift kitty
  fi

  install_packages fortune-mod cowsay figlet
  fortune linux | cowsay -f tux

  log_packages
}

main "$@"
