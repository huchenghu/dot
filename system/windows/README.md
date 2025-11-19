# Windows

```sh
runas /user:administrator cmd
```

## 链接

- [Win11 ISO](https://www.microsoft.com/en-us/software-download/windows11)
- [rufus](https://github.com/pbatard/rufus)

- [windows privacy](https://learn.microsoft.com/en-us/windows/privacy)
- [privacy.sexy](https://github.com/undergroundwires/privacy.sexy)
- [Dism++](https://github.com/Chuyu-Team/Dism-Multi-language)
- [PowerToys](https://github.com/microsoft/PowerToys)
- [Visual Studio](https://visualstudio.microsoft.com/)
- [Scoop](https://scoop.sh/)

## 微调

```sh
# 禁用所有设备唤醒，只允许电源键唤醒（无效？）
powercfg /devicequery wake_armed | foreach{ powercfg /devicedisablewake $_ }

# 禁用快速启动FastBoot
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 0 /f

# 将CapsLock映射为Ctrl，或者在PowerToys内修改
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d "0000000000000000020000001d003a0000000000"

# UTC时间
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /v "RealTimeIsUniversal" /t REG_DWORD /d 1
```

## 修复引导

[修复偶然删除的EFI分区](https://wiki.archlinux.org/title/Dual_boot_with_Windows#Restoring_an_accidentally_deleted_EFI_system_partition)

```sh
# 刻录Windows.iso镜像到U盘，启动到U盘
# 在安装界面，按Shift+F10打开终端
X:\Sources> diskpart
DISKPART> list disk
# 选择包含EFI分区的硬盘编号
DISKPART> select disk <number>
DISKPART> list partition
# 选择EFI分区编号，分配盘符
DISKPART> select partition <number>
DISKPART> assign letter=G:
# DiskPart successfully assigned the drive letter or mount point.
DISKPART> list vol
DISKPART> exit
# 导航到系统盘符
X:\Sources> cd /d C:\
# Windows Boot Manager
C:\> bcdboot C:\Windows /s G: /f UEFI

# 编辑引导
cmd(admin)
bcdedit
```

## 修复系统

最简单的方法：下载Windows安装ISO，双击装载ISO并运行`setup.exe`，选择保留文件并重装系统

[repair a windows image](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/repair-a-windows-image)

```sh
# 以管理员权限启动终端
PowerShell(admin)

# DISM(Deployment Image Servicing and Management)使用Windows Update修复系统文件
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth

# 如果Windows Update已损坏，指定同版本ISO镜像内install.wim或其他电脑Windows目录作为修复源
# 获取install.wim中同版本Windows Index
DISM /Get-WimInfo /WimFile:install.wim
DISM /Online /Cleanup-Image /StartComponentCleanup
DISM /Online /Cleanup-Image /AnalyzeComponentStore
DISM /Online /Cleanup-Image /RestoreHealth /Source:WIM:D:\sources\install.wim:6 /LimitAccess
DISM /Online /Cleanup-Image /RestoreHealth /Source:C:\RepairSource\Windows /LimitAccess

# 等待sfc(System File Checker)100%完成
sfc /scannow
```

```sh
# 修复Windows Update

# 以管理员权限启动终端
cmd(admin)

net stop bits
net stop wuauserv
net stop appidsvc
net stop cryptsvc

Del "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\*.*"
rmdir %systemroot%\SoftwareDistribution /S /Q
rmdir %systemroot%\system32\catroot2 /S /Q

netsh winsock reset

net start bits
net start wuauserv
net start appidsvc
net start cryptsvc
```

```sh
# 恢复Microsoft Store

Win+R wsreset
C:\Windows\SoftwareDistribution\Download
```

## WSL

```sh
wsl --list
wsl --terminate debian
wsl --shutdown
wsl --list --online
wsl --install debian # 需要github网络
wsl --set-default debian

C:\Users\User\AppData\Local\Packages\TheDebianProject.DebianGNULinux_76v4gfsz19hv4\LocalState\rootfs
```

```sh
# WSL2访问Windows（虚拟机访问宿主机，如访问宿主机的代理端口），需要添加防火墙规则放行
New-NetFirewallRule -DisplayName "WSL" -Direction Inbound  -InterfaceAlias "vEthernet (WSL)"  -Action Allow
# 如果无效，重置防火墙重新添加规则
```

```sh
# systemd
# /etc/wsl.conf
[boot]
systemd=true
```
