# Fontconfig

## 常用字体

- `Noto Sans/Serif CJK SC` `Source Han Sans/Serif SC`
  - 可以显示大部分中文字体，避免字形缺失，且有宋体、黑体
  - 适合作为中文的默认字体
- `Noto Sans Mono` `Source Code Pro`
  - 有良好的英文字形区分
  - 适合作为英文的默认字体
- `Noto Sans Mono CJK SC`
  - 可以解决中英对齐问题，英文偏窄，基线过高，0O区分不明显
  - 适合需要中英对齐的场景，如中英混合的文本表格、代码等
- `Sarasa Mono/Term SC`
  - 可以解决中英对齐问题，英文偏窄
  - 适合需要中英对齐的场景，如中英混合的文本表格、代码等
- `Fira Code`
  - 有良好的英文字形区分，连体字
  - 适合作为代码字体
- `Nerd Font`
  - 有丰富的图形

### Noto / Source Han

- `Sans` 无衬线体，中文中类似黑体
- `Serif` 衬线体，中文中类似宋体
- `Mono` 等宽字体
- `Emoji` 表情图标

- `CJK` Chinese Japanese Korean
- `HK` Hong Kong
- `JP` Japanese
- `KR` Korean
- `SC` Simplified Chinese
- `TC` Traditional Chinese

- `ttf: TrueType Font`
- `ttc: TrueType Collection`

- `Noto Sans CJK` ≈ 思源黑体
- `Noto Serif CJK` ≈ 思源宋体

### Sarasa

| 风格   | 等宽 | 弯引号 | 破折号 | 连字 |
| ------ | ---- | ------ | ------ | ---- |
| Gothic | 否   | 全宽   | 全宽   | 否   |
| UI     | 否   | 半宽   | 全宽   | 否   |
| Mono   | 是   | 半宽   | 全宽   | 是   |
| Term   | 是   | 半宽   | 半宽   | 是   |
| Fixed  | 是   | 半宽   | 半宽   | 否   |

| 字形 |                     |                    |
| ---- | ------------------- | ------------------ |
| CL   | Classical           | 旧体汉字           |
| HC   | HongKong Chinese    | 香港繁体和澳门繁体 |
| J    | Japanese            | 日本语             |
| K    | Korean              | 朝鲜语/韩语        |
| SC   | Simplified Chinese  | 简体中文           |
| TC   | Traditional Chinese | 繁体中文           |

- `slab` 带衬线字体
- `extralight`, `light`, `regular`, `semibold`, `bold`共五种字重，每种字重加`italic`为斜体，共十种

## 字体顺序

- `/etc/fonts/fonts.conf`及`/etc/fonts/conf.d/*`设置了系统的字体优先顺序
- `~/.config/fontconfig/fonts.conf`设置了用户的字体优先顺序

```sh
# `man fonts-conf`
# ~/.fonts.conf
# ~/.config/fontconfig/fonts.conf
cp /dotfiles/pathto/.fonts.conf ~/.config/fontconfig/fonts.conf

# 查看字体顺序列表
fc-match -s monospace | head
fc-match -s sans-serif | head
fc-match -s serif | head

# 如果字体顺序有误，重新生成cache
fc-cache -fv
# 或者sudo执行
sudo dpkg-reconfigure fontconfig fontconfig-config
```

英文环境默认选中字体：

- `Serif: Noto Serif`
- `Sans-Serif: Noto Sans`
- `Monospace: Noto Sans Mono`

中文环境默认选中字体：

- `Serif: Noto Serif CJK SC`
- `Sans-Serif: Noto Sans CJK SC`
- `Monospace: Noto Sans Mono`

## 中英字体对齐

```sh
每个英文字母占一个字宽
每个中文汉字占两个字宽
Each English letter occupies one character width
Each Chinese character occupies two characters width

0123456789      0123456789
一二三四五      一二三四五
abcdefghij      abcdefghij

0123456789      0123456789
一二三abcd      一二三abcd
ab一c二d三      ab一c二d三
```

## 相似字形区分

```sh
aaaaaaaaaa \
oooooooooo \
OOOOOOOOOO \
0000000000 \
QQQQQQQQQQ \
CCCCCCCCCC \
GGGGGGGGGG \
gggggggggg \
9999999999 \
qqqqqqqqqq \
iiiiiiiiii \
IIIIIIIIII \
llllllllll \
1111111111 \
|||||||||| \
丨丨丨丨丨(中文的 shu)
```
