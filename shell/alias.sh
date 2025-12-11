# alias.sh -----------------------------------------------------------------{{{

# 一些别名
# 别名尽可能不覆盖原名
# 别名命名尽可能贴近原命令参数
# 别名命名过长时尽可能方便使用<Tab>补全（首字母不同）
# 有一些别名并不使用，仅作备忘

# --------------------------------------------------------------------------}}}

# if not running interactively, don't do anything --------------------------{{{

[[ $- != *i* ]] && return

# --------------------------------------------------------------------------}}}

# standard -----------------------------------------------------------------{{{

# safe overwrite -----------------------------------------------------------{{{

alias cp='cp -i'
alias mkdir='mkdir -p'
alias mv='mv -i'
alias rm='rm -i'

# --------------------------------------------------------------------------}}}

# enable color support -----------------------------------------------------{{{

if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
alias dir='dir --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls -h --color=auto' # --group-directories-first GNU coreutils
alias vdir='vdir --color=auto'

# --------------------------------------------------------------------------}}}

# some more ls aliases -----------------------------------------------------{{{

alias l='ls -CF'
alias la='ls -AF'
alias ll='ls -lAF'
alias lle='ll -e'               # list ACL
alias lli='ll -i'               # list inode
alias lln='ll -n'               # list numeric user/group id
alias lls='ll -sS'              # sort by size
alias llt='ll -t --full-time'               # sort by modification time
alias llta='ll --time=atime --full-time'    # sort by access time
alias lltb='ll --time=birth --full-time'    # sort by birth time
alias lltc='ll --time=ctime --full-time'    # sort by change time
alias llx='ll -XB'              # sort by extension
alias llz='ll -Z'               # print security context
# find . -inum 12345 -exec vi {} \;

# --------------------------------------------------------------------------}}}

# short --------------------------------------------------------------------{{{

# cd ..
alias ..='cd ..'
alias ...='cd .. && cd ..'
alias ....='cd .. && cd .. && cd ..'

alias e='exit'

# --------------------------------------------------------------------------}}}

# human output -------------------------------------------------------------{{{

alias dfa='df -hTa'
alias dfh='df -hT'
alias dfi='df -hTi'
alias du1='du -hxd 1 | sort -h'
alias du2='du -hxd 2 | sort -h'
alias du3='du -hxd 3 | sort -h'
alias echopath='echo -e ${PATH//:/\\n}'
alias ipa='ip -color a'
alias lessr='less -R'
alias psf='ps -flyj --forest'
alias psfe='ps -flyj --forest -e'

# btop(top) ripgrep(grep) fd-find(find) fzf tldr(man)
#alias fd='fdfind'

# --------------------------------------------------------------------------}}}

# network ------------------------------------------------------------------{{{

# debian etherwake wakeonlan
#alias wol=wakeonlan

# --------------------------------------------------------------------------}}}

# date ---------------------------------------------------------------------{{{

alias date-day="date +%Y-%m-%d"
alias date-day-week="date +%Y-%m-%d-%u"
alias date-min="date +%Y-%m-%d-%H-%M"
alias date-sec="date +%Y-%m-%d-%H-%M-%S"

# --------------------------------------------------------------------------}}}

# --------------------------------------------------------------------------}}}

# GUI ----------------------------------------------------------------------{{{

# 设置系统启动时不启动到图形界面，手动启动(GDM/SDDM)
# sudo systemctl get-default
# sudo systemctl set-default multi-user.target

# GNOME
alias gdmstart='sudo systemctl start gdm'

# KDE startplasma-wayland
alias sddmstart='sudo systemctl start sddm'

# gio
alias gtrash='gio trash'
alias gtree='gio tree'

# xdg
alias xo='xdg-open'

# --------------------------------------------------------------------------}}}

# debian apt ---------------------------------------------------------------{{{

# upgrade
alias sudo-apt-upgrade='w -i \
  && sudo apt update \
  && sudo apt upgrade \
  && sudo apt-mark minimize-manual \
  && sudo apt autopurge \
  && sudo apt autoclean \
  && dpkg-query --list \
  | sudo tee /root/pkgs-$(date +%Y-%m-%d-%H-%M).txt > /dev/null \
  && apt-mark showmanual \
  | sudo tee /root/pkgs-manual-$(date +%Y-%m-%d-%H-%M).txt > /dev/null '

alias sau='sudo-apt-upgrade'

# full upgrade
# apt full-upgrade is NOT SAFE
alias sudo-apt-full-upgrade='w -i \
  && sudo apt update \
  && sudo apt full-upgrade \
  && sudo apt-mark minimize-manual \
  && sudo apt autopurge \
  && sudo apt autoclean \
  && dpkg-query --list \
  | sudo tee /root/pkgs-$(date +%Y-%m-%d-%H-%M).txt > /dev/null \
  && apt-mark showmanual \
  | sudo tee /root/pkgs-manual-$(date +%Y-%m-%d-%H-%M).txt > /dev/null '

alias saf='sudo-apt-full-upgrade'

# man apt-patterns
# 清除残留config 不再被依赖的包garbage 无法再下载的包obsolete
alias apt-list-garbage='apt list ?config-files ?garbage ?obsolete'
alias sudo-apt-purge-garbage='sudo apt purge ?config-files ?garbage' # ?obsolete

# unattended upgrade 无人值守更新 测试
alias sudo-unattended-upgrade-debug='sudo unattended-upgrade -d --dry-run'

# --------------------------------------------------------------------------}}}

# arch pacman --------------------------------------------------------------{{{

alias pacman-aur='pacman -Qm '
alias pacman-info='pacman -Sii '
alias pacman-search='pacman -Ss '
alias pacman-showmanual='pacman -Qe '

alias sudo-pacman-autoremove='sudo pacman -Qdtq | sudo pacman -Rns - '
alias sudo-pacman-check='sudo pacman -Syy && sudo pacman -Dk && sudo pacman -Qkkq '
alias sudo-pacman-clean='sudo pacman -Scc '
alias sudo-pacman-minimize='comm -23 <(pacman -Qqe | sort) <(pacman -Qqet | sort) | sudo pacman -D --asdeps - '

alias sudo-pacman-upgrade='w -i \
  && sudo pacman -Syu \
  && sudo pacman -Dkq \
  && sudo pacman -Qkq \
  && pacman -Q \
  | sudo tee /root/pkgs-$(date +%Y-%m-%d-%H-%M).txt > /dev/null'

alias spu='sudo-pacman-upgrade'

alias sudo-pacman-install='sudo pacman -Syu && sudo pacman --needed -S '
alias spi='sudo-pacman-install '

alias sudo-pacman-remove='sudo pacman -Rns '
alias spr='sudo-pacman-remove '

# --------------------------------------------------------------------------}}}

# monitor ------------------------------------------------------------------{{{

# temperature lm-sensors
alias watch-fan='watch -d -n 2 "sensors | grep -E \"(fan|Package)\""'
alias watch-nvidia='watch -d -n 2 nvidia-smi'
alias watch-sensors='watch -d -n 2 sensors'

# --------------------------------------------------------------------------}}}

# tmux ---------------------------------------------------------------------{{{

alias tm='tmux'
alias tma='tmux attach '
alias tml='tmux ls'
alias tmn='tmux new '
alias tmnd='tmux new -d '

# --------------------------------------------------------------------------}}}

# editors ------------------------------------------------------------------{{{

# vim
alias nv='nvim'
alias vi='vim'
alias viu='vim -Nu NONE'
alias vix='vim -x'
alias vireadme='vim ./README.md'
alias vitoday='vim $(date +%Y-%m-%d-%u).md'

# emacs
alias ec-kill-server='emacsclient --eval "(save-buffers-kill-emacs)"'
alias ec='emacsclient -t -a ""'
alias em='emacs'
alias emq='emacs -Q'
alias en='emacs -nw'
alias es='emacs --daemon'
alias sec='sudo emacsclient -t -a ""'

# --------------------------------------------------------------------------}}}

# gpg ----------------------------------------------------------------------{{{

# gpg --full-gen-key
alias gpg-ll='gpg --list-secret-keys --keyid-format=long'
# gpg --armor --export <sec ID>

# --------------------------------------------------------------------------}}}

# git ----------------------------------------------------------------------{{{

alias gad='git add --all -v'
alias gba='git branch --list --all'
alias gca='git commit --all -v'
alias gcam='git commit --amend'
alias gcl='git clean -diX'
alias gcla='git clean -dix'
alias gcs='git commit -S'
alias gdf1='git diff HEAD~1'
alias gdf2='git diff HEAD~2'
alias gdf='git diff'
alias gdfs='git diff --staged'
alias glg='git log --graph --text --oneline'
alias glgs='git log --graph --text --oneline --stat'
alias glga='git log --graph --text --stat --all'
alias glgp='git log --graph --text --patch'
alias gpl='git pull'
alias gps='git push'
alias gref='git reflog'
alias grv='git remote -v'
alias gsh='git show'
alias gst='git status -bsvv'
alias gsw='git switch'
alias gtgl='git tag --list'
alias gwc='git ls-files | xargs wc -l'

# more aliases
# git config --global include.path /path/to/alias.gitconfig

# --------------------------------------------------------------------------}}}

# rsync --------------------------------------------------------------------{{{

# rsync                          同步 源目录/ --> 目标目录/ 是将两个目录下内容同步
#                                同步 源目录 --> 目标目录 是同步源目录到目标目录下
# -a                             --archive, = -rlptgoD(no -AXUNH), 存档模式同步
# 注：只有拥有修改权限才能同步源文件所有权等信息到目标文件
# --acls, -A                     保存ACLs
# --xattrs, -X                   保存extended attributes
# --atimes, -U                   保存access (use) times
# --crtimes, -N                  保存create times (newness)
# --hard-links, -H               保存hard links
# --sparse, -S                   turn sequences of nulls into sparse blocks
# --append-verify                从中断处继续传输，完成后校验
# -b                             --backup, 如果删除或更新目标目录中文件，备份
# --backup-dir                   备份路径
# -c                             --checksum, 检查校验和，而非文件大小和日期
# --delete                       删除，如果文件在源目录中不存在而目标目录存在
# --delete-during                同步时删除，可以配合增量递归减少内存使用，默认
# --exclude                      指定排除不进行同步的文件
# -h                             --human-readable, 人类可读的输出
# -i                             --itemize-changes, 输出文件差异详细情况
# --ignore-non-existing          忽略目标目录中不存在的文件，只更新已存在的文件
# --include                      指定同步的文件
# --link-dest                    指定增量备份的基准目录
# -m                             --prune-empty-dirs, 不同步空目录
# --mkpath                       创建多级目标目录
# -n                             --dry-run, 模拟执行，-v查看
# --progress                     显示进度
# -P                             --partial --progress, 断点续传并显示进度
# -r                             --recursive, 默认增量递归，减少内存使用
# --remove-source-files          传输完成后，删除源目录文件
# -u                             --update, 更新，即跳过目标目录中修改时间更新的文件
# -v -vv -vvv                    显示输出信息，更详细，最详细的信息
# -x                             --one-file-system，不备份挂载文件系统
# -z                             --compress, 同步时压缩数据

# 测试同步 (a^_old,b^,c^) --> (a_new,b,d) = (a^_old,b^,c^,d)
alias rsync-test-override='rsync -n -aczP --mkpath -hi'
# 测试同步 (a^,b^,c^_old) --> (a,b,c_new,d) = (a^,b^,c_new,d)
alias rsync-test-update='rsync -n -acuzP --mkpath -hi'
# 测试同步 (a^,b^,c^) --> (a,b,d) = (a^,b^,c^)
alias rsync-test-update-delete='rsync -n -acuzP --delete --mkpath -hi'
# 测试同步 (a^,b^,c^) --> (a,b,d) = (a^,b^,d)
alias rsync-test-update-ignore='rsync -n -acuzP --ignore-non-existing --mkpath -hi'
# 测试备份当前目录(pwd)到
alias rsync-test-backup-pwd-to='rsync -n -aczP --delete --mkpath -hi $(pwd) '

# 实施同步
alias rsync-override='rsync -aczP --mkpath -hi'
alias rsync-update-delete='rsync -acuzP --delete --mkpath -hi'
alias rsync-update-ignore='rsync -acuzP --ignore-non-existing --mkpath -hi'
alias rsync-update='rsync -acuzP --mkpath -hi'

# backup
alias rsync-backup-pwd-to='rsync -acuzP --delete --mkpath -hi $(pwd) '
alias rsync-backup-system-to='rsync -acuxzPAXUNHS --delete --mkpath -hi --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / '
alias rsync-restore-system-to='rsync -acuxzPAXUNHS --delete --mkpath -hi --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} '

# --------------------------------------------------------------------------}}}

# pandoc -------------------------------------------------------------------{{{

#eval "$(pandoc --bash-completion)"
alias pandoc-pdf='pandoc --pdf-engine=xelatex \
  -V mainfont="Noto Serif CJK SC" \
  -V sansfont="Noto Sans CJK SC" \
  -V monofont="Noto Sans Mono" \
  -V CJKmainfont="Noto Serif CJK SC" \
  -V CJKsansfont="Noto Sans CJK SC" \
  -V CJKmonofont="Noto Sans Mono" '

# --------------------------------------------------------------------------}}}

# latex clean --------------------------------------------------------------{{{

alias xelatex-clean='rm -rfv *.toc *.vrb *.aux *.log *.nav *.out *.snm *.synctex.gz'

# --------------------------------------------------------------------------}}}
