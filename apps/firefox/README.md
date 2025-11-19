# Firefox

## user.js

用户配置(`~/.mozilla/firefox/xxx.default/user.js`)，仅在本profile中生效，用户可以生成和切换多个profile `firefox -> help -> more troubleshooting -> profile directory`

- [arkenfox user.js](https://github.com/arkenfox/user.js)
- [arkenfox dashboard](https://arkenfox.github.io/gui/)

## 默认配置

默认配置，所有使用此版本firefox的用户都受此配置影响，其格式与`user.js`类似，`user_pref()` --> `pref()`

- `/etc/firefox-esr/firefox-esr.js`
- `/etc/firefox/syspref.js`
- `/usr/lib/firefox/defaults/pref/syspref.js`

[autoconfig](https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig)

## 其他配置方式

- [策略](https://mozilla.github.io/policy-templates/)
