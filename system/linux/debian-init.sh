#!/bin/bash

# init debian

echoinfo() {
  #echo -e "\e[32m[INFO]\e[0m"
  unset ARG
  for ARG in "$@"
  do
    echo -e "\e[32m$ARG\e[0m"
  done
  unset ARG
}

echowarning() {
  #echo -e "\e[33m[WARNING]\e[0m"
  unset ARG
  for ARG in "$@"
  do
    echo -e "\e[33m$ARG\e[0m"
  done
  unset ARG
}

echoerror() {
  #echo -e >&2 "\e[31m[ERROR]\e[0m"
  unset ARG
  for ARG in "$@"
  do
    echo -e >&2 "\e[31m$ARG\e[0m"
  done
  unset ARG
}

log_packages() {
  echo
  echowarning "log installed packages"

  echo
  echoinfo "dpkg-query --list | sudo tee /root/pkgs-$(date +%Y-%m-%d-%H-%M).txt > /dev/null"
  dpkg-query --list | sudo tee "/root/pkgs-$(date +%Y-%m-%d-%H-%M).txt" > /dev/null

  echo
  echoinfo "dpkg-query --list | wc -l"
  dpkg-query --list | wc -l

  echo
  echoinfo "sudo apt-mark minimize-manual"
  sudo apt-mark minimize-manual -y

  echo
  echoinfo "apt-mark showmanual | sudo tee /root/pkgs-manual-$(date +%Y-%m-%d-%H-%M).txt > /dev/null"
  apt-mark showmanual | sudo tee "/root/pkgs-manual-$(date +%Y-%m-%d-%H-%M).txt" > /dev/null

  echo
  echoinfo "apt-mark showmanual | wc -l"
  apt-mark showmanual | wc -l
}

install_packages() {
  local packages=("$@")
  echoinfo "${packages[@]}"
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
    echowarning "install GUI"
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
