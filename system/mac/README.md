# Mac

- [homebrew](https://brew.sh)

## TODO

- [x] 修复Mac默认bash版本过低
- [x] 修复Mac默认ls不支持将目录排在文件前面，使用GNU coreutils
- [x] 修复`git-prompt`
- [x] `setup-cpp`适配`MacOS`
- [ ] 清除`.DS_Store` `__MACOSX`
- [ ] 命令行配置系统`defaults`

## Tweaks

```sh
# 不生成`.DS_Store`
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.desktopservices DSDontWriteDesktopStores -bool true
killall Finder

# 程序坞弹出延迟
defaults write com.apple.dock autohide-delay -int 0
killall Dock
```

## 快捷键

| 快捷键            | Windows/Linux(Gnome)     | MacOS                |
| :---------------- | :----------------------- | :------------------- |
| 窗口              |                          |                      |
| 全屏              | F11                      | Ctrl+Command+F       |
| 最大化/填充       | Win+上                   | Ctrl+Fn+F            |
| 退出最大化        | Win+下                   |                      |
| 居中              |                          | Ctrl+Fn+C            |
| 左分屏            | Win+左                   | Ctrl+Fn+左           |
| 右分屏            | Win+右                   | Ctrl+Fn+右           |
| 显示/隐藏桌面     | Win+D                    | F11                  |
| 全局搜索          | Alt+Space(PowerToys Run) | Command+Space(聚焦)  |
| 切换窗口/应用程序 | Alt+Tab                  | Command+Tab/`        |
| 显示工作区        | Win+Tab                  | Ctrl+上              |
| 显示当前应用窗口  |                          | Ctrl+下              |
| 切换工作区        | Win+Ctrl+左/右           | Ctrl+左/右           |
| 切换输入法        | Win+Space Shift          | Ctrl+Space CapsLock  |
| 退出应用          | Alt+F4                   | Command+Q            |
| 锁屏              | Win+L                    | Ctrl+Command+Q       |
| 文本              |                          |                      |
| 全选              | Ctrl+A                   | Command+A            |
| 剪切              | Ctrl+X                   | Command+X            |
| 复制              | Ctrl+C                   | Command+C            |
| 粘贴              | Ctrl+V                   | Command+V            |
| 撤销              | Ctrl+Z                   | Command+Z            |
| 重做              | Ctrl+Y                   | Command+Shift+Z      |
| 保存              | Ctrl+S                   | Command+S            |
| 搜索              | Ctrl+F                   | Command+F            |
| 返回/前进         | Alt+左/右                | Command+Option+左/右 |
