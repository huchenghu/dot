# .bashrc

[[ $- != *i* ]] && return

# opt ----------------------------------------------------------------------{{{

complete -o default -F _cd -o nospace cd pushd
set -o emacs                # emacs/readline keymode
set -o notify               # notify background job completion
shopt -s execfail           # prevent shell exit on failed exec
shopt -s histappend         # append to the history file, don't overwrite it
stty -ixon                  # disable ctrl-s/q suspend session
ulimit -c 0                 # disable core dumps 'ulimit -c unlimited'

HISTCONTROL=ignoreboth      # ignoreboth=ignorespace, ignoredups
HISTFILESIZE=10000
HISTIMEFORMAT="%F %T "      # add timestamp to history entries
HISTSIZE=10000
PS1='\[\e[07;40;37m\][\h \u \w]\[\e[00m\] [\D{%y-%m-%d} \A] [$SHLVL \j $?]\n> '

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
    "/opt/homebrew/etc/profile.d/bash_completion.sh"
    "/etc/profile.d/bash_completion.sh"
  )

  for script in "${scripts[@]}"; do
    if [[ -r "$script" ]]; then
      source "$script"
    fi
  done
}
_source_extended_scripts
unset _source_extended_scripts

# --------------------------------------------------------------------------}}}
