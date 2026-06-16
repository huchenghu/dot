#!/bin/bash

# preconditions ------------------------------------------------------------{{{

# Arch Live ISO archinstall
#
# Network[WiFi]
#   ip link
#   rfkill unblock wifi
#   ip link set [wlan0] up
#   iwctl
#     device list
#     station [wlan0] scan
#     station [wlan0] get-networks
#     station [wlan0] connect [wifi-ssid]
#     station [wlan0] show
#     exit
#   ping archlinux.org
# Partition
#   lsblk
#   time dd if=/dev/zero of=/dev/[sda/nvme0n1] bs=4M
#   cfdisk /dev/[sda/nvme0n1]
#   fdisk -l
#   fdisk /dev/[sda/nvme0n1]
#     # gpt
#     > g
#     # EFI   /dev/[sda1/nvme0n1p1]
#     > n     # +1/2G
#     > t     # uefi  EFI system partition
#     # root  /dev/[sda2/nvme0n1p2]
#     > n     # +256G
#     > t     # 23    Linux root(x86-64)
#     # swap  /dev/[sda3/nvme0n1p3]
#     > n     # +2G/memory size
#     > t     # swap  Linux swap
#     # home  /dev/[sda4/nvme0n1p4]
#     > n     # +max
#     > t     # 20    Linux filesystem
#     > p
#     > w
#   lsblk
# File System
#   lsblk -f
#   mkfs.fat -F 32 -n ARCH_BOOT /dev/[sda1/nvme0n1p1]
#   mkfs.ext4 -L ARCH_ROOT /dev/[sda2/nvme0n1p2]
#   mkswap -L ARCH_SWAP /dev/[sda3/nvme0n1p3]
#   mkfs.ext4 -L ARCH_HOME /dev/[sda4/nvme0n1p4]
#   # fatlabel(install dosfstools) /dev/xxx <label>
#   # e2lable /dev/xxx <label>
#   # swaplabel -L <lable> /dev/xxx
#   tune2fs -i 7 -c 1 /dev/[sdaX/nvme0n1pX]
#   lsblk -f
# Mount
#   mount LABEL=ARCH_ROOT /mnt
#   mount --mkdir -o uid=0,gid=0,fmask=0077,dmask=0077 LABEL=ARCH_BOOT /mnt/boot
#   swapon -L ARCH_SWAP
#   mount --mkdir LABEL=ARCH_HOME /mnt/home
# Genfstab
#   # genfstab -L /mnt >> /mnt/etc/fstab
#   # genfstab -U /mnt >> /mnt/etc/fstab

# sftp username@dotfiles-server
# >get -r dotfiles
# Init
#   root passwd
#   add user
#   hostname
#   locale
#   timezone
#   firmware
#   boot
#   firewall
#   network

# --------------------------------------------------------------------------}}}



# check --------------------------------------------------------------------{{{

echo
echo "verify the boot mode?"
read -rp "<Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
  ls /sys/firmware/efi/efivars
fi

echo
echo "check internet and time?"
read -rp "<Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
  echo
  echo "ip -br --color link"
  ip -br --color link

  echo
  echo "ping archlinux.org -c 5"
  ping archlinux.org -c 5

  echo
  echo "timedatectl status"
  timedatectl status
fi

# --------------------------------------------------------------------------}}}

# pacman -------------------------------------------------------------------{{{

echo
echo "set /etc/pacman.d/mirrorlist?"
read -rp "<Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
  sudo tee /etc/pacman.d/mirrorlist <<'EOF'
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.nju.edu.cn/archlinux/$repo/os/$arch
EOF

echo
echo "EDITOR=vim sudo -e /etc/pacman.d/mirrorlist"
EDITOR=vim sudo -e /etc/pacman.d/mirrorlist

echo "EDITOR=vim sudo -e /etc/pacman.conf"
EDITOR=vim sudo -e /etc/pacman.conf

sudo pacman -Syy
echo "sudo pacman -S --needed archlinux-keyring"
sudo pacman -S --needed archlinux-keyring
#sudo pacman -Syu
fi

# --------------------------------------------------------------------------}}}

# bootstrap ----------------------------------------------------------------{{{

echo
echo "ls -l /mnt"
ls -l /mnt

echo
echo "[LIVE] pacstrap -K /mnt?"
read -rp "<Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
  echo "[LIVE] base base-devel linux linux-firmware"
  echo "[LIVE] sudo openssh vim networkmanager"
  pacstrap -K /mnt base base-devel \
    linux linux-firmware \
    openssh vim curl \
    networkmanager \
    #linux-zen
fi

echo
echo "[LIVE] genfstab -L /mnt?"
read -rp "<Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
  echo "cp -v /mnt/etc/fstab /mnt/etc/fstab.bak"
  cp -v /mnt/etc/fstab /mnt/etc/fstab.bak

  echo "genfstab -L /mnt >> /mnt/etc/fstab"
  genfstab -L /mnt >> /mnt/etc/fstab
fi

echo
echo "[LIVE] cp -rLu /dotfiles /mnt?"
read -rp "<Y/n> " prompt
if [[ "$prompt" == "y" || "$prompt" == "Y" || "$prompt" == "" ]]; then
  echo "cp -rLu /dotfiles /mnt"
  cp -rLu /dotfiles /mnt
fi

echo
echo "[LIVE] arch-chroot /mnt"

# --------------------------------------------------------------------------}}}
