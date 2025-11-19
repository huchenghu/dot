# prompt.sh ----------------------------------------------------------------{{{

# 一个简单的prompt
# [hostname username dirs] (main *+>)
# [$]:

# 可以在git repo中显示仓库细节，但可能拖慢prompt速度，尤其是大仓库，如linux.git
# 使用_git_prompt_disable临时禁用git prompt
# 使用_git_prompt_enable临时启用git prompt

# 前置条件
#   git-prompt.sh

# --------------------------------------------------------------------------}}}

# if not running interactively, don't do anything --------------------------{{{

[[ $- != *i* ]] && return

# --------------------------------------------------------------------------}}}

# prompt -------------------------------------------------------------------{{{

_bash_simple_prompt() {
  # https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html
  unset PS1
  unset PROMPT_COMMAND
  PS1='\[\e[07;40;37m\][\h \u \w]\[\e[00m\] [\D{%y-%m-%d} \A] [$SHLVL \j $?]\n> '
}

_zsh_simple_prompt() {
  prompt restore
  unset PROMPT
  unset RPROMPT
  PROMPT="%K{white}%{$fg[black]%}[%m %n %~]%{$reset_color%} [%D %T] [%L %j %?]%k"$'\n'
  PROMPT+="> "
  #RPROMPT="[%? %L]"
}

_git_prompt_setting() {
  # arch: /usr/share/git/completion/git-prompt.sh
  # debian: /usr/lib/git-core/git-sh-prompt
  # fedora: /usr/share/git-core/contrib/completion/git-prompt.sh
  # dotfiles: $HOME/dotfiles/git/scripts/git-prompt.sh

  if [[ -r "$HOME/dotfiles/shell/git-prompt.sh" ]]; then
    source "$HOME/dotfiles/shell/git-prompt.sh"

    # unstaged (*) staged (+)
    GIT_PS1_SHOWDIRTYSTATE=1

    # stashed ($)
    GIT_PS1_SHOWSTASHSTATE=1

    # untracked files (%)
    GIT_PS1_SHOWUNTRACKEDFILES=1

    # differ between HEAD and upstream
    # you are behind (<)
    # you are ahead (>)
    # you have diverged (<>)
    # no difference (=)
    GIT_PS1_SHOWUPSTREAM="auto"

    # more info
    GIT_PS1_DESCRIBE_STYLE=default

    # color
    GIT_PS1_SHOWCOLORHINTS=1

    # hide if ignored by git
    GIT_PS1_HIDE_IF_PWD_IGNORED=1
  else
    echo -e >&2 "\n\e[31m[ERROR]\e[0m: git-prompt.sh load failed!\n"
  fi
}

_bash_git_prompt() {
  if _git_prompt_setting; then
    # color !only available by PROMPT_COMMAND in bash
    PROMPT_COMMAND='__git_ps1 '
    # string before git info
    PROMPT_COMMAND+='"\[\e[07;40;37m\][\h \u \w]\[\e[00m\] [\D{%y-%m-%d} \A] [$SHLVL \j $?]" '
    # string after git info
    PROMPT_COMMAND+='"\n> " '
    # git info
    PROMPT_COMMAND+='" (%s)"'
  else
    _bash_simple_prompt
  fi
}

_zsh_git_prompt() {
  if _git_prompt_setting; then
    prompt restore
    precmd() {
      PROMPT="%K{white}%{$fg[black]%}[%m %n %~]%{$reset_color%} [%D %T] [%L %j %?]%k$(__git_ps1 " (%s)")"$'\n'
      PROMPT+="> "
      #RPROMPT="[%? %L]"
    }
  else
    _zsh_simple_prompt
  fi
}

# --------------------------------------------------------------------------}}}

# _git_prompt_enable() -----------------------------------------------------{{{

_git_prompt_enable() {
  if [ -n "$BASH_VERSION" ]; then
    _bash_git_prompt
  elif [ -n "$ZSH_VERSION" ]; then
    _zsh_git_prompt
  else
    echo -e >&2 "\n\e[31m[ERROR]\e[0m: neither bash nor zsh, set shell prompt failed!\n"
  fi
}

# --------------------------------------------------------------------------}}}

# _git_prompt_disable() ----------------------------------------------------{{{

_git_prompt_disable() {
  if [ -n "$BASH_VERSION" ]; then
    _bash_simple_prompt
  elif [ -n "$ZSH_VERSION" ]; then
    _zsh_simple_prompt
  else
    echo -e >&2 "\n\e[31m[ERROR]\e[0m: neither bash nor zsh, set shell prompt failed!\n"
  fi
}

# --------------------------------------------------------------------------}}}
