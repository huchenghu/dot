# .zshrc

[[ $- != *i* ]] && return

# opt ----------------------------------------------------------------------{{{

autoload -Uz colors && colors
autoload -Uz compinit && compinit -u
autoload -Uz promptinit && promptinit
bindkey -e
setopt completealiases
setopt extended_glob
setopt extended_history           # fc -li
setopt histignorealldups
setopt notify
setopt sharehistory
stty -ixon
ulimit -c 0
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

prompt restore
PROMPT="%K{white}%{$fg[black]%}[%m %n %~]%{$reset_color%} [%D %T] [%L %j %?]%k"$'\n'
PROMPT+="> "
#RPROMPT="[%? %L]"

# --------------------------------------------------------------------------}}}

# source scripts -----------------------------------------------------------{{{

_source_dotfiles_scripts() {
  local -a scripts=(
    "$HOME/dotfiles/shell/alias.sh"
    "$HOME/dotfiles/shell/environment.sh"
    "$HOME/dotfiles/shell/functions.sh"
    "$HOME/dotfiles/shell/prompt.sh"
  )

  for script in "${scripts[@]}"; do
    if [[ -r "$script" ]]; then
      source "$script"
    fi
  done
}
_source_dotfiles_scripts
unset _source_dotfiles_scripts

_source_extended_scripts() {
  local -a scripts=(
    "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  )

  for script in "${scripts[@]}"; do
    if [[ -r "$script" ]]; then
      source "$script"
    fi
  done
}
_source_extended_scripts
unset _source_extended_scripts

_git_prompt_enable

# --------------------------------------------------------------------------}}}
