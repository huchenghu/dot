# environment.sh -----------------------------------------------------------{{{

# 环境变量

# !!!此配置不是最佳实践!!!
# !!!环境变量应当在`*profile`中设置而不是在`*shrc`中设置!!!
#
# `/etc/profile` --> `~/.bash_profile` --> `~/.bashrc`
# `*profile`在登录Shell（如SSH登录、终端登录）时加载，仅执行一次
# `*shrc`在非登录Shell（如新建终端窗口、运行子Shell）时每次加载

# --------------------------------------------------------------------------}}}

# if not running interactively, don't do anything --------------------------{{{

[[ $- != *i* ]] && return

# --------------------------------------------------------------------------}}}

# umask --------------------------------------------------------------------{{{

# -rw-r--r-- -rwxr-xr-x default
umask 0022

# -rw-r----- -rwxr-x---
#umask 0027

# --------------------------------------------------------------------------}}}

# path ---------------------------------------------------------------------{{{

# /etc/profile
#if [ "$(id -u)" -eq 0 ]; then
#  PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
#else
#  PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
#fi

# ~/.profile
if [[ -d "$HOME/.local/bin" ]]; then
  PATH="$HOME/.local/bin:$PATH"
fi

if [[ -d "$HOME/dotfiles/scripts" ]]; then
  PATH="$HOME/dotfiles/scripts:$PATH"
fi

export PATH

# --------------------------------------------------------------------------}}}

# locale -------------------------------------------------------------------{{{

# - `LANG` 默认语言
#   - 所有未显式设置的 `LC_*` 变量会使用 `LANG` 的参数
#   - `C.UTF-8`: Computer bytes/ASCII
# - `LANGUAGE` 缺省语言（桌面环境，图形界面等）
#   - 仅当 `LC_ALL` 和 `LANG` 没有被设置为 'C.UTF-8' 时生效
# - `LC_ALL` 格式（时间，单位等）
#   - `LC_ALL=C.UTF-8` 覆盖所有的 `LC_*` 设置

# only for shell environment
export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# --------------------------------------------------------------------------}}}

# editors ------------------------------------------------------------------{{{

export EDITOR='vim'
#export VISUAL='vim'
#export PAGER='less'

# --------------------------------------------------------------------------}}}

# gpg ----------------------------------------------------------------------{{{

if [[ -d "$HOME/.gnupg" ]]; then
  export GPG_TTY="$(tty)"
fi

# --------------------------------------------------------------------------}}}

# logout -------------------------------------------------------------------{{{

# timeout 3600s=1h 7200s=2h 18000s=5h
export TMOUT=7200

# --------------------------------------------------------------------------}}}

# homebrew -----------------------------------------------------------------{{{

# homebrew
if [[ -d "/opt/homebrew" ]]; then
  export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
  export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
  export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

  # brew analytics
  export HOMEBREW_NO_ANALYTICS=1
  # hints
  export HOMEBREW_NO_ENV_HINTS=1
  # auto update
  export HOMEBREW_NO_AUTO_UPDATE=1
  # HTTPS
  export HOMEBREW_NO_INSECURE_REDIRECT=1
  # cask sha
  export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications --require-sha"

  # 在zprof耗时统计中耗时占比60%以上
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # PATH
  #if [[ -d "/opt/homebrew/opt/coreutils/libexec/gnubin" ]]; then
  #  PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
  #fi
  if [[ -d "/opt/homebrew/opt/llvm/bin" ]]; then
    PATH="/opt/homebrew/opt/llvm/bin:$PATH"
  fi
  export PATH
fi

# --------------------------------------------------------------------------}}}

# misc ---------------------------------------------------------------------{{{

# cargo
if [[ -r "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# vcpkg
if [[ -r "$HOME/vcpkg" ]]; then
  export PATH="$HOME/vcpkg:$PATH"
  export VCPKG_CUSTOM="$HOME/vcpkg/scripts/buildsystems/vcpkg.cmake"
  export VCPKG_MAX_CONCURRENCY=8
fi

# --------------------------------------------------------------------------}}}
