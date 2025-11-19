# Arch Linux

**注意**：以官方文档为准，本文件可能未更新。

## Secure Boot

**注意**：使用自己的密钥替换平台的密钥会瘫痪某些机器（比如笔记本）上的硬件，甚至无法进入UEFI/BIOS设置恢复。这是因为某些硬件的固件（OpROMs）在启动时使用微软的密钥进行签署。

[`sbctl`](https://github.com/Foxboron/sbctl)

```sh
# reboot into UEFI menu
# disable secure boot
# enable custom key mode
# enable setup mode

# install sbctl
sudo pacman -Syu
sudo pacman -S --needed sbctl
sudo sbctl status
# Setup Mode: Enabled
# Secure Boot: Disabled

# keys
sudo sbctl create-keys
sudo sbctl enroll-keys # --microsoft

# reboot
sudo sbctl status
# Setup Mode: Disabled
# Secure Boot: Disabled

# sign
sudo sbctl verify
sudo sbctl sign --save /boot/EFI/systemd/systemd-bootx64.efi
sudo sbctl sign --save /boot/EFI/BOOT/BOOTX64.EFI
sudo sbctl sign --save /boot/vmlinuz-linux
sudo sbctl verify
sudo sbctl list-files

# reboot into UEFI menu
# enable secure boot
# keep custom key mode on
```

## NVIDIA

NVIDIA更多信息见官方wiki

- [arch wiki nvidia](https://wiki.archlinux.org/title/NVIDIA)
- [arch wiki nvidia tips](https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks)

```sh
# hardware info
lspci -k | grep -A 2 -E "(VGA|3D)"

# boot into tty
sudo systemctl set-default multi-user.target
sudo reboot

# enable multlib
#sudo -e /etc/pacman.conf # multlib

# install `nvidia-open` driver for kernel `linux`
sudo pacman -Syu
sudo pacman -S --needed base-devel linux-headers dkms
sudo pacman -S --needed nvidia-open nvidia-utils # lib32-nvidia-utils
sudo pacman -S --needed nvidia-settings # nvidia-prime

# install intel driver (DO NOT install xf86-video-intel)
sudo pacman -S --needed mesa mesa-utils \
                        vulkan-intel \
                        # lib32-mesa \
                        # lib32-vulkan-intel

# add kernel parameters, modesetting mode
sudo -e /etc/modprobe.d/nvidia.conf
# options nvidia_drm modeset=1 fbdev=1
# options nvidia NVreg_PreserveVideoMemoryAllocations=1

# mkinitcpio.conf
sudo -e /etc/mkinitcpio.conf
# HOOKS=(... kms ...), remove `kms`
# MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm), add nvidia*

# regenerate initramfs
sudo mkinitcpio -P

# check after reboot
sudo reboot
sudo cat /sys/module/nvidia_drm/parameters/modeset # Y
sudo cat /proc/driver/nvidia/params | grep Preserve # 1

# pacman hook
sudo mkdir -p /etc/pacman.d/hooks
sudo cp nvidia-open-linux.hook /etc/pacman.d/hooks/

# enable nvidia services
sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service
sudo systemctl enable nvidia-resume.service

# start GUI
sudo systemctl start gdm # sddm

# if wayland not shown on gdm
# disable check in /usr/lib/udev/rules.d/61-gdm.rules
sudo ln -sv /dev/null /etc/udev/rules.d/61-gdm.rules
```
