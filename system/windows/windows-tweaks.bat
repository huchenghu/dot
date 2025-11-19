@echo off

:FastBoot
echo "FastBoot"
choice /m "Disable Fast Boot(y) or Enable(n)?"
if %errorlevel% equ 1 goto DisableFastBoot
if %errorlevel% equ 2 goto EnableFastBoot

:DisableFastBoot
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 0 /f
goto CapsCtrl

:EnableFastBoot
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f
goto CapsCtrl

:CapsCtrl
echo "Caps Ctrl"
choice /m "Set Caps->Ctrl(y) or Reset(n)?"
if %errorlevel% equ 1 goto SetCapsCtrl
if %errorlevel% equ 2 goto ResetCapsCtrl

:SetCapsCtrl
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d "0000000000000000020000001d003a0000000000"
goto UTCTime

:ResetCapsCtrl
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d "0000000000000000000000000000000000000000"
goto UTCTime

:UTCTime
echo "UTC Time"
choice /m "Set UTC Time(y) or Reset(n)?"
if %errorlevel% equ 1 goto SetUTCTime
if %errorlevel% equ 2 goto ResetUTCTime

:SetUTCTime
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /v "RealTimeIsUniversal" /t REG_DWORD /d 1
goto LongPath

:ResetUTCTime
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /v "RealTimeIsUniversal" /t REG_DWORD /d 0
goto LongPath

:LongPath
echo "LongPath"
choice /m "LongPath Enable(y) or Not(n)?"
if %errorlevel% equ 1 goto EnableLongPath
if %errorlevel% equ 2 goto Tray

:EnableLongPath
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathEnabled" /t REG_DWORD /d 1
goto Tray

:Tray
echo "Clean Tray"
choice /m "Clean Tray(y) or exit(n)?"
if %errorlevel% equ 1 goto CleanTray
if %errorlevel% equ 2 goto TheEnd

:CleanTray
reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v "IconStreams" /f
reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v "PastIconsStream" /f
goto TheEnd

:TheEnd
pause
