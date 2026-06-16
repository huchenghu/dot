#!/bin/bash

# init debian

log_packages() {
  echo
  echo "log installed packages"

  echo
  echo "dpkg-query --list | sudo tee /root/pkgs-$(date +%Y-%m-%d-%H-%M).txt > /dev/null"
  dpkg-query --list | sudo tee "/root/pkgs-$(date +%Y-%m-%d-%H-%M).txt" > /dev/null

  echo
  echo "dpkg-query --list | wc -l"
  dpkg-query --list | wc -l

  echo
  echo "sudo apt-mark minimize-manual"
  sudo apt-mark minimize-manual -y

  echo
  echo "apt-mark showmanual | sudo tee /root/pkgs-manual-$(date +%Y-%m-%d-%H-%M).txt > /dev/null"
  apt-mark showmanual | sudo tee "/root/pkgs-manual-$(date +%Y-%m-%d-%H-%M).txt" > /dev/null

  echo
  echo "apt-mark showmanual | wc -l"
  apt-mark showmanual | wc -l
}

install_packages() {
  local packages=("$@")
  echo "${packages[@]}"
  sudo apt install -y "${packages[@]}"
}

main() {
  log_packages

  install_packages sudo
  sudo apt update
  sudo apt upgrade -y

  install_packages tasksel task-english
  sudo tasksel install standard
  sudo tasksel install english

  install_packages build-essential
  install_packages ssh tmux vim
  install_packages bash bash-completion
  install_packages zsh zsh-autosuggestions zsh-syntax-highlighting
  install_packages curl git rsync
  install_packages zip unzip p7zip-full

  install_packages htop fzf fd-find ripgrep
  install_packages ranger

  if false; then
    echo "install GUI"
    install_packages fonts-noto fonts-firacode
    install_packages gnome-core gnome-tweaks ibus-libpinyin
    install_packages gnome-shell-extension-appindicator
    install_packages gnome-shell-extension-dash-to-panel

    install_packages firefox-esr chromium vlc timeshift kitty
  fi

  install_packages figlet fortunes fortunes-zh cowsay
  /usr/games/fortune linux | /usr/games/cowsay -f tux

  log_packages
}

main "$@"
