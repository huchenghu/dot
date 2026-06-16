# .zshrc

[[ $- != *i* ]] && return

# opt ----------------------------------------------------------------------{{{

autoload -Uz colors && colors
autoload -Uz promptinit && promptinit
bindkey -e
setopt completealiases
setopt extended_glob
setopt extended_history           # fc -li
setopt histignorealldups
setopt no_beep
setopt notify
setopt incappendhistory
setopt appendhistory
stty -ixon
ulimit -c 0
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
REPORTTIME=5
SAVEHIST=10000

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit -i
else
  compinit -C -i
fi

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
  local zsh_autosuggest_path zsh_syntax_highlighting_path

  if [[ -d "/opt/homebrew/share" ]]; then
    zsh_autosuggest_path="/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    zsh_syntax_highlighting_path="/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  elif [[ -d "/usr/share/zsh/plugins" ]]; then
    zsh_autosuggest_path="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    zsh_syntax_highlighting_path="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  elif [[ -d "/usr/share" ]]; then
    zsh_autosuggest_path="/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    zsh_syntax_highlighting_path="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  fi

  if [[ -n "$zsh_autosuggest_path" && -r "$zsh_autosuggest_path" ]]; then
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_USE_ASYNC=true
    source "$zsh_autosuggest_path"
  fi

  if [[ -n "$zsh_syntax_highlighting_path" && -r "$zsh_syntax_highlighting_path" ]]; then
    source "$zsh_syntax_highlighting_path"
  fi
}
_source_extended_scripts
unset _source_extended_scripts

if command -v _git_prompt_enable &>/dev/null; then
  _git_prompt_enable
fi

# --------------------------------------------------------------------------}}}
