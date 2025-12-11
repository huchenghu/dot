# functions.sh -------------------------------------------------------------{{{

# 一些函数

# --------------------------------------------------------------------------}}}

# if not running interactively, don't do anything --------------------------{{{

[[ $- != *i* ]] && return

# --------------------------------------------------------------------------}}}

# time shell ---------------------------------------------------------------{{{

# 测试shell加载时间，100ms/0.100s以上会有非常明显的延迟
timeshell() {
  which -a bash

  echo
  echo "time bash --norc -i -c exit"
  time bash --norc -i -c exit

  echo
  echo "time bash -i -c exit"
  time bash -i -c exit

  echo
  which -a zsh

  echo
  echo "time zsh --norcs -i -c exit"
  time zsh --norcs -i -c exit

  echo
  echo "time zsh -i -c exit"
  time zsh -i -c exit
}

echocolors() {
  echo -e "\e[0;30mBLACK\e[0m \e[0;31mRED\e[0m \e[0;32mGREEN\e[0m \e[0;33mORANGE\e[0m \e[0;34mBLUE\e[0m \e[0;35mPURPLE\e[0m \e[0;36mCYAN\e[0m \e[0;37mWHITE\e[0m"
  echo -e "\e[1;30mBLACK\e[0m \e[1;31mRED\e[0m \e[1;32mGREEN\e[0m \e[1;33mORANGE\e[0m \e[1;34mBLUE\e[0m \e[1;35mPURPLE\e[0m \e[1;36mCYAN\e[0m \e[1;37mWHITE\e[0m"
}

# --------------------------------------------------------------------------}}}

# backup -------------------------------------------------------------------{{{

# rsync aliases 可以实现简单快速的备份

backuptohome() {
  local target
  if [[ $# -eq 0 ]]; then
    target="$(pwd)"
  else
    target="$1"
  fi

  local backup_name="$(date +%Y%m%d-%H%M%S)-$(basename "$target")"
  local backup_path="$HOME/.backup/$backup_name"

  echo
  echo -e "backup \e[32m[$target]\e[0m"
  echo -e "    to \e[32m[$backup_path]\e[0m"
  rsync -aczP --mkpath -hi "$target" "$backup_path"
}

# --------------------------------------------------------------------------}}}

# bookmark -----------------------------------------------------------------{{{

# firefox备份书签格式化，去除日期及无用链接等
bookmarkformat() {
  local ARG
  for ARG in "$@"; do
    python3 -c 'import json, sys

filename = sys.argv[1]
with open(filename, "r") as f:
    data = json.load(f)

def remove_keys(obj):
    if isinstance(obj, dict):
        for key in ["guid", "dateAdded", "lastModified", "iconUri"]:
            obj.pop(key, None)
        for v in obj.values():
            remove_keys(v)
    elif isinstance(obj, list):
        for item in obj:
            remove_keys(item)

remove_keys(data)

with open(filename, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)' "$ARG"
  done
}

# --------------------------------------------------------------------------}}}

# chmod format -------------------------------------------------------------{{{

chmod755644() {
  echo "chmod: dir 755, file 644"
  find ./* -type d -exec chmod -v 755 {} \;
  find ./* -type f -exec chmod -v 644 {} \;
  #setfacl -bR .
}

chmod750640() {
  echo "chmod: dir 750, file 640"
  find ./* -type d -exec chmod -v 750 {} \;
  find ./* -type f -exec chmod -v 640 {} \;
  #setfacl -bR .
}

chmod700600() {
  echo "chmod: dir 700, file 600"
  find ./* -type d -exec chmod -v 700 {} \;
  find ./* -type f -exec chmod -v 600 {} \;
  #setfacl -bR .
}

# --------------------------------------------------------------------------}}}

# custom update ------------------------------------------------------------{{{

customupdate() {
  echo "update $1 $2"
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "[ERROR] string is empty!"
  else
    if [ -e "$2.old" ]; then
      echo "[WARNING] remove $2.old!"
      rm -v -rfv "$2.old"
    fi
    if [ -e "$2" ]; then
      mv -v "$2" "$2.old"
    fi

    cp -Lruv "$1" "$2"
    chmod -cv 600 "$2"

    echo "[custom] $2"
    if [ -e "$2.old" ]; then
      awk '/\[custom\]/ {i=1;next};i' "$2.old" >> "$2"
      awk '/\[custom\]/ {i=1;next};i' "$2"
      #rm -v $2.old
    fi
  fi
}

# --------------------------------------------------------------------------}}}

# echo ---------------------------------------------------------------------{{{

# echo [INFO] [WARNING] [ERROR]
# Black         0;30    Dark Gray       1;30
# Red           0;31    Light Red       1;31
# Green         0;32    Light Green     1;32
# Orange        0;33    Yellow          1;33
# Blue          0;34    Light Blue      1;34
# Purple        0;35    Light Purple    1;35
# Cyan          0;36    Light Cyan      1;36
# Light Gray    0;37    White           1;37

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

# --------------------------------------------------------------------------}}}

# proxy --------------------------------------------------------------------{{{

proxyon() {
  export https_proxy="http://127.0.0.1:1080"
  export http_proxy="http://127.0.0.1:1080"
  export all_proxy="socks5://127.0.0.1:1080"
  echo "https_proxy:  $https_proxy"
  echo "http_proxy:   $http_proxy"
  echo "all_proxy:    $all_proxy"
  echo "no_proxy:     $no_proxy"
  echo "proxy on"
}

proxyoff() {
  unset https_proxy http_proxy all_proxy no_proxy
  echo "https_proxy:  $https_proxy"
  echo "http_proxy:   $http_proxy"
  echo "all_proxy:    $all_proxy"
  echo "no_proxy:     $no_proxy"
  echo "proxy off"
}

proxyecho() {
  echo "https_proxy:  $https_proxy"
  echo "http_proxy:   $http_proxy"
  echo "all_proxy:    $all_proxy"
  echo "no_proxy:     $no_proxy"
}

proxytest() {
  echo
  echo "curl -s -m 5 https://httpbin.org/get"
  curl -s -m 5 https://httpbin.org/get
  echo
  echo "curl -s -m 5 --socks5 127.0.0.1:1080 https://httpbin.org/get"
  curl -s -m 5 --socks5 127.0.0.1:1080 https://httpbin.org/get
  echo
  echo "curl -s -m 5 https://google.com"
  curl -s -m 5 https://google.com
}

# --------------------------------------------------------------------------}}}

# text ---------------------------------------------------------------------{{{

findinfiles() {
  find ./* -type f | xargs grep --color=always "$1" | less -R
}

sedinfiles() {
  sed -i "s/$1/$2/g" "$(grep "$1" -rl "*")"
}

head10() {
  awk '{print $1}' $1 | sort | uniq -c | sort -nr | head -10
}

# --------------------------------------------------------------------------}}}

# zip ----------------------------------------------------------------------{{{

p7za(){
  7z a -tzip -xr!'*.DS_Store*' -xr!'*/__MACOSX*' -xr!'._*' "$(basename $(pwd))-$(date +%Y%m%d-%H%M%S)"
}

p7zx() {
  7z x -r "$1" -o"${$(basename "$1")%.*}"
}

# --------------------------------------------------------------------------}}}
