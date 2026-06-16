#!/usr/bin/env bash

# init macOS

log_packages() {
  echo
  echo "log installed packages"

  echo
  echo "brew list > /tmp/brew-pkgs-$(date +%Y-%m-%d-%H-%M).txt"
  brew list > "/tmp/brew-pkgs-$(date +%Y-%m-%d-%H-%M).txt"

  echo
  echo "brew list | wc -l"
  brew list | wc -l
}

install_packages() {
  local packages=("$@")
  echo "packages: ${packages[@]}"
  brew install "${packages[@]}"
}

install_casks() {
  local casks=("$@")
  echo "casks: ${casks[@]}"
  brew install --cask "${casks[@]}"
}

main() {
  log_packages

  brew update
  brew upgrade

  install_packages coreutils bash zsh vim git tmux rsync
  install_packages zsh-autosuggestions zsh-syntax-highlighting
  install_packages fzf ripgrep sevenzip yazi

  install_casks font-fira-code font-fira-code-nerd-font

  install_casks firefox kitty visual-studio-code utm
  #install_casks obsidian wechat wpsoffice-cn

  brew cleanup

  log_packages
}

main "$@"
