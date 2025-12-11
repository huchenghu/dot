#!/usr/bin/env bash

# init macOS

echoinfo() {
  unset ARG
  for ARG in "$@"
  do
    echo -e "\e[32m$ARG\e[0m"
  done
  unset ARG
}

echowarning() {
  unset ARG
  for ARG in "$@"
  do
    echo -e "\e[33m$ARG\e[0m"
  done
  unset ARG
}

echoerror() {
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
  echoinfo "brew list > /tmp/brew-pkgs-$(date +%Y-%m-%d-%H-%M).txt"
  brew list > "/tmp/brew-pkgs-$(date +%Y-%m-%d-%H-%M).txt"

  echo
  echoinfo "brew list | wc -l"
  brew list | wc -l
}

install_packages() {
  local packages=("$@")
  echoinfo "packages: ${packages[@]}"
  brew install "${packages[@]}"
}

install_casks() {
  local casks=("$@")
  echoinfo "casks: ${casks[@]}"
  brew install --cask "${casks[@]}"
}

main() {
  log_packages

  brew update
  brew upgrade

  install_packages \
    bash zsh zsh-autosuggestions zsh-syntax-highlighting \
    git tmux vim rsync

  install_packages htop p7zip fzf yazi neovim

  install_casks font-fira-code font-fira-code-nerd-font

  install_casks kitty firefox visual-studio-code

  #install_casks utm obsidian

  #install_casks wpsoffice-cn wechat

  brew cleanup

  log_packages
}

main "$@"
