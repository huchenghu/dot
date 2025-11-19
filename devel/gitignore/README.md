# Git

## Git用户配置

```sh
# 帮助手册
# git子命令加`--help`查看手册
git config --help

# [全局/当前]仓库配置用户名和邮箱
git config [--global] user.name "username"
git config [--global] user.email "useremail"

# [全局/当前]仓库默认编辑器
git config [--global] core.editor vim
# [全局/当前]仓库默认diff编辑器
git config [--global] diff.tool vim # vimdiff/vscode/meld/...

# 编辑[全局/当前]仓库配置文件
git config [--global] -e
```

## 仓库

```sh
repo:
------ remote repository ------ ------ ------ ------ ------ ------ ------
|               ^                                       |               |
|clone          |push                                   |fetch          |pull(fetch+merge)
v               |                                       v               |reset --hard remote/branch
------ local repository ------ ------ ------ ------ ------              |
|               ^               |                       |               |
|checkout HEAD  |commit [-a]    |reset HEAD [filename]  |merge          |
|switch [-c]    |               |restore --staged       |reset --hard   |
|               |               v                       |rebase         |
|----- staged/index ------ ------ ------ ------ ------ -|revert         |
|               ^               |                       |cherry-pick    |
|               |add/mv/rm      |checkout filename      |               |
|               |               |restore filename       |               |
v               |               v                       v               v
------ workspace ------ ------ ------ ------ ------ ------ ------ ------
|               ^
|stash          |stash apply/pop
v               |
------ stash ----
```

### 创建仓库

```sh
# 初始化仓库
git init
# 初始化bare仓库（没有工作区文件的仓库，可以接收推送）
git init --bare
# 克隆远程仓库到本地
git clone git@git-server-ip:/path/to/repo.git
```

### 远程仓库

```sh
# 查看远程库信息
git remote -v
# 更新远程库
git fetch
# 将远程库最新修改更新到本地
git pull # git fetch + git merge
# 将本地修改推送到远程库
git push [origin branch-name]
# 检出分支
git checkout <branch-name>
# 将本地分支与远程分支关联
git branch --track <branch-name> origin/<branch-name>
```

### 添加文件到仓库

```sh
# 添加文件到暂存区/索引区(staged/index)
# 添加单个文件
git add <filename>
# 添加所有文件
git add --all
# 编辑.gitignore设置会被忽略的文件

# 提交到仓库
git commit --all --message="init repo"
# 查看工作区状态
git status --branch --short --verbose
# 对比工作区和暂存区/索引区(staged/index)
git diff
# 对比暂存区/索引区(staged/index)和上次提交(repo)
git diff --staged
```

### 回退版本

```sh
# 查看过去版本
git log
git log --pretty=oneline
# 查看历史提交及被回退的提交
git reflog # 仅限本地记录

# 回退版本
# 回退到当前最新提交
git reset --hard HEAD
# 回退到上次提交
git reset --hard HEAD^
# 回退到上n次提交
git reset --hard HEAD~n
git reset --hard HEAD@{n}
# 回退到某次提交
git reset --hard commitid
```

### 撤销修改

```sh
# 撤销没有提交到暂存区/索引区(staged/index)，即没有`git add`的修改
# 用暂存区/索引区该文件的修改记录（即最后一次add后的记录）覆盖工作区
git checkout <filename>

# 撤销提交到暂存区/索引区但是没有提交到本地仓库，即没有`git commit`的修改
# 用本地仓库该文件的修改记录（即最后一次commit后的记录）覆盖暂存区/索引区
git reset HEAD <filename>
# 再用暂存区/索引区该文件的修改记录（即最后一次commit后的记录）覆盖工作区
git checkout <filename>
# 合并为一步
git reset --hard HEAD <filename>

# 撤销提交到本地仓库，即已经`git commit`的修改
# 用本地仓库该文件的上次修改记录（即倒数第二次commit后的记录）覆盖暂存区/索引区
git reset HEAD^
# 再用暂存区/索引区该文件的修改记录（即倒数第二次commit后的记录）覆盖工作区
git checkout <filename>
# 合并为一步
git reset --hard HEAD^
```

### 删除/重命名文件

```sh
# 从仓库删除文件，本地也同步删除文件
git rm <filename>

# 从仓库删除文件/文件夹，但本地不删除文件/文件夹
git rm --cached <filename>
git rm --cached -r <dir/>

# 删除工作区中忽略的文件
git clean -di
# 删除工作区中未被追踪的文件
git clean -dix [dir/]

# 删除未添加.gitignore前错误提交的文件（删除错误文件重新提交）
# 已经被管理的文件即使被加入了gitignore也会被追踪，所以只能从仓库删除重新提交
git rm --cached -r <dir/> <filename>
git add --all
git commit --all

# 重命名文件文件夹
git mv <file-old-name> <file-new-name>
```

### 查看提交信息

```sh
git show HEAD
git show HEAD~1
git show HEAD~1:<filename>
```

### gitignore

配置git忽略哪些文件及文件夹

- 使用`git check-ignore -v filename`检查`.gitignore`规则
- 使用`git add -f filename`强制添加跟踪
- 使用`git rm [-r] --cached [filename]`移除跟踪

#### 配置优先级

- 命令行参数
- 当前`.gitignore`及任何从当前目录直到仓库根目录的`.gitignore`中的匹配模式
- `$GIT_DIR/info/exclude`
- `core.excludesFile`

- 仓库通用的忽略配置存储在`.gitignore`
- 仓库特定的忽略配置存储在`$GIT_DIR/info/exclude`
- 用户默认的忽略配置存储在`$XDG_CONFIG_HOME/git/ignore`
- 用户默认的忽略配置存储位置可通过`.gitconfig core.excludesFile`修改

#### 匹配模式规则 Pattern Format

- 空行不匹配任何文件
- `#`开头的行为注释
- `foo`匹配所有以`foo`为名的文件或文件夹，递归深入目录，如`foo`, `bar/foo`
- `!`否定忽略规则
  - 被之前匹配模式所匹配的忽略文件将再次被包含
    - 如`!foo`将不再忽略`foo`文件或文件夹
  - 如果排除了该文件的父目录则无法重新包含该文件
- `/`为路径分割符
  - 如果匹配模式的开头或中间有`/`，则匹配与该`.gitignore`文件所在目录相关
    - 如`/foo`匹配`.gitignore`所在的同级目录中的`foo`文件或文件夹
    - 如`foo/bar`和`/foo/bar`作用相同，不深入目录，都不匹配`bar/foo/bar`
    - 如果需要匹配多级目录需要使用`**`
  - 如果匹配模式的末尾有`/`，则只匹配目录，否则匹配文件和目录
    - 如`foo/`匹配`foo/`, `bar/foo/`, 深入目录
    - 而`foo/bar`只匹配`foo/bar`, 不匹配`bar/foo/bar`，不深入目录
- `*`匹配任意个字符
  - 如果不包含`/`，则匹配任意路径
    - 如`*.txt`匹配`foo.txt`, `bar.txt`, `bar/foo.txt`, `foo/bar/foo.txt`
  - 如果开头或中间包含`/`，则按照`/`规则，不递归深入目录
    - 如`bar/*.txt`只匹配`bar/foo.txt`, 不匹配`foo/bar/foo.txt`
- `**`匹配任意个字符，无限递归深入目录
  - 如`/**`匹配`.gitignore`目录下的所有文件及文件夹
  - 如`**/foo`匹配`.gitignore`目录下的所有`foo`文件及文件夹
  - 如`foo/**/bar`匹配`foo/bar`, `foo/a/bar`, `foo/a/b/bar`
- `?`匹配任意一个字符，遇到`/`中止
- `[a-zA-Z]`匹配范围内的一个字符

唯一需要注意的是`/`出现在中间时，等同于出现在开头，匹配不深入目录，深入目录需要使用`**`

## 分支

来源：[`CS Visualized: Useful Git Commands`](https://dev.to/lydiahallie/cs-visualized-useful-git-commands-37p1)

```sh
Merge:
    `main$ git merge dev`: fast-forward(--ff)
    --- main ---    --- dev ---             --- main ---    --- dev ---
                    76d12                   76d12 <- [HEAD][main][dev]
                    |                       |
                    |                       v
    ec5be[HEAD] <---o           ==>         ec5be
    |                                       |
    v                                       v
    i8fe5                                   i8fe5

    `main$ git merge dev`: no-fast-forward(--no-ff)
    --- main ---    --- dev ---             --- main ---    --- dev ---
                                            9e78i[HEAD] ----o
                                            |               |
                                            v               v
    035cc[HEAD]     e3475                   035cc           e3475
    |               |           ==>         |               |
    v               v                       v               v
    ec5be           76d12                   ec5be           76d12
    |               |                       |               |
    v               |                       v               |
    i8fe5       <---o                       i8fe5       <---o

    merge conflicts:
    CONFLICT (content)
    Merge conflict in README.md
    `main$ vi README.md`
    `main$ git commit -a`

Rebase:
    `dev$ git rebase main`:
    --- main ---    --- dev ---             --- main ---    --- dev ---
                                                                3a2e2[HEAD]
                                                                |
                                                                v
                        e3475[HEAD]                             e45cb
                        |                                       |
                        v                                       |
    ec5be               76d12                   ec5be       <---o
    |                   |                       |
    v                   |                       v
    i8fe5           <---o                       i8fe5

    `main$ git rebase -i HEAD~3`:
    --- main ---    --- main ---
    3a2e2[HEAD]
    |
    v
    e45cb               9ae53[HEAD]
    |                   |
    v           ==>     v
    ec5be               c4ec9
    |                   |
    v                   v
    i8fe5               i8fe5

Reset:
    `main$ git reset --soft HEAD~2`:
    --- main ---    --- main ---
    3a2e2[HEAD]         3a2e2
    |                   |
    v                   v
    e45cb               e45cb
    |                   |
    v           ==>     v
    ec5be               ec5be[HEAD]
    |                   |
    v                   v
    i8fe5               i8fe5

    `main$ git reset --hard HEAD~2`:
    --- main ---    --- main ---
    3a2e2[HEAD]
    |
    v
    e45cb
    |
    v           ==>
    ec5be               ec5be[HEAD]
    |                   |
    v                   v
    i8fe5               i8fe5

Revert:
    `dev$ git revert ec5be`:
    --- dev ---         --- dev ---
                        9e78i[HEAD](-README.md)
                        |
                        v
    035cc[HEAD]         035cc
    |                   |
    v                   v
    ec5be(+README.md)   ec5be(+README.md)
    |                   |
    v                   v
    i8fe5               i8fe5

Cherry-pick:
    `main$ git cherry-pick 76d12`
    --- main ---    --- dev ---             --- main ---    --- dev ---
                                            9e78i[HEAD](+README.md)
                                            |
                                            v
    035cc[HEAD]     76d12(+README.md)       035cc           76d12(+README.md)
    |               |               ==>     |               |
    v               v                       v               v
    035cd           89u7e                   035cd           89u7e
    |               |                       |               |
    v               |                       v               |
    i8fe5       <---o                       i8fe5       <---o

Fetch:
    `main$ git fetch`:
    --- main ---    --- remote ---              --- main ---    --- remote ---
                    7e456[origin/master]        7e456           7e456[origin/master]
                    |                           |               |
                    v                           v               v
                    efi81                       efi81           efi81
                    |               ==>         |               |
                    v                           v               v
    035cc[HEAD]     035cc                       035cc[HEAD]     035cc
    |               |                           |               |
    v               v                           v               v
    i8fe5           i8fe5                       i8fe5           i8fe5

Pull:
    pull = fetch + merge
```

### 创建合并分支

```sh
# 创建本地分支
git branch <branch-name>
# 创建并切换本地分支
git checkout -b <branch-name>
# 切换分支
git checkout <branch-name>
# 合并分支 [合并分支时禁用fast forward]
git merge [--no-ff] <branch-name>
```

### 查看删除分支

```sh
# 查看当前分支
git branch --list
# 查看所有分支（本地分支和远程分支）
git branch --all
# 查看分支状态
git log --graph --oneline
# 删除本地已合并分支
git branch --delete branch-name
# 删除本地未合并分支
git branch --delete --force branch-name
# 删除远程分支
git push <remote-name> --delete <branch-name>
```

### 暂存修改

```sh
# 暂存工作现场
git stash
# 恢复工作现场
git stash apply     # 恢复
git stash drop      # 删除
git stash pop       # 恢复删除
```

### 版本标签Tag

```sh
# Tag 仅可读的branch
# 查看Tag
git tag --list
# 添加Tag
git tag <tagname> [commitid]
# 删除本地Tag
git tag --delete <tagname>
# 删除远程Tag
git push origin --delete <tagname>
# 推送Tag到远程仓库
git push origin <tagname>
git push origin --tags
# 更新Tag到本地
git pull origin --tags
```

## 协作

### 提交规范

[Kernel提交规范](https://docs.kernel.org/process/submitting-patches.html#describe-your-changes)

[emacs提交规范](https://github.com/emacs-mirror/emacs/blob/master/CONTRIBUTE#L171)

[约定式提交](https://www.conventionalcommits.org/)

[Git Emoji](https://gitmoji.dev/)

~~提交信息不填`.`就是胜利！~~

### 功能分支(feature branch)

通过创建功能分支的方式开发新功能，并在完成之后将功能分支推送到远程仓库并提交拉取请求(`Pull Requests`)，在代码审查之后合并到主分支。该工作流程可以是其他流程的基础。

```sh
# 检出主分支并保持其更新
git checkout main
git fetch origin
git reset --hard origin/main

# 创建功能分支
git checkout -b feature-branch main

# 添加功能，提交
git status
git add files
git commit

# 推送功能分支到远程仓库
git push -u origin feature-branch

# 远程仓库审查代码，提出修改意见，修改
# 通过则远程管理可将该功能分支合并进主分支
# 没有远程管理则在本地将功能分支合并进主分支并推送至远程仓库

# 本地将功能合并进主分支
git checkout main
git pull
git pull origin feature-branch
# 此时可能会出现合并提示(merge)，处理冲突并合并，或者变基(rebase)以保持线性提交记录
git push
```

### 发行分支(main/release branch)和开发分支(develop branch)

`git-flow`工作流以`功能分支`为基础，将`主分支`用于跟踪发行记录，另在主分支上创建`开发分支`用于跟踪开发记录。

```sh
# 在主分支上创建开发分支
git checkout main
git checkout -b develop
# 在开发分支上创建新功能分支
git checkout develop
git checkout -b feature-branch
# 新功能开发完成后合并回开发分支
git checkout develop
git merge feature-branch
git branch -d feature-branch
# 准备发行，从开发分支创建发行分支，之后该发行分支不再添加新功能，仅作错误修复、文档更新等
git checkout develop
git checkout -b release/0.1.0
# 准备好发行后，将该发行分支合并回开发分支，同时合并进主分支
git checkout develop
git merge release/0.1.0
git checkout main
git merge release/0.1.0

# 在主分支上创建紧急热修复分支
git checkout main
git checkout -b hotfix-branch
# 热修复完成后将热修复分支合并进开发分支和主分支
git checkout develop
git merge hotfix-branch
git checkout main
git merge hotfix-branch
```

### 分叉(fork)

分叉(`fork`)即是服务器端的克隆(`clone`)

分叉工作流常见于公共开源项目，首先创建官方远程仓库的副本，并在副本远程仓库上开发，开发完成后向官方远程仓库提交拉取请求(`Pull Requests`)。开发者推送到自己的副本远程仓库，只有项目维护者可以推送到官方远程仓库。这允许项目维护者接受任何开发者的提交，而无需授予他们对官方仓库的写入权限。

## Git proxy

以`127.0.0.1:1080`为例

### http proxy

代理`http`流量(`https://git-server/username/reponame.git`)

```sh
# 终端代理
export http_proxy="http://127.0.0.1:1080"
export https_proxy="http://127.0.0.1:1080"
export all_proxy="socks5://127.0.0.1:1080"
# 取消终端代理
unset http_proxy
unset https_proxy
unset all_proxy

# proxychains
# /etc/proxychains.conf # socks5 127.0.0.1 1080
proxychains git clone https://git-server/username/reponame.git
proxychains curl/wget -v example.com

# git http proxy
git config [--global] http.proxy 'socks5://127.0.0.1:1080'
git config [--global] https.proxy 'socks5://127.0.0.1:1080'
```

### ssh proxy

代理`ssh`流量(`git@git-server:username/reponame.git`)

```sh
# ~/.ssh/config
Host github-proxy
  Hostname github.com
  Port 22
  User git
  PreferredAuthentications publickey,password
  IdentityFile ~/.ssh/github
  # openbsd-netcat
  ProxyCommand nc -x 127.0.0.1:1080 %h %p
```

一些防火墙可能会拒绝通过`ssh 22`连接，可以使用[`SSH over HTTPS`](https://docs.github.com/en/authentication/troubleshooting-ssh/using-ssh-over-the-https-port)

```sh
Host github-https
  Hostname ssh.github.com
  Port 443
  User git
  PreferredAuthentications publickey,password
  IdentityFile ~/.ssh/github
```

### 镜像站

```sh
# 镜像站网址仅作举例，具体可用镜像站地址搜索关键词`github mirror`
https://xxx.gitxxx.xxx
# git clone
git clone https://xxx.gitxxx.xxx/xxx/xxx.git
# git config
git config --global url."https://xxx.gitxxx.xxx".insteadOf https://github.com
```

## git server

- [`git book`](https://git-scm.com/book)中的`git on server`章节有各种配置的介绍
- [`arch wiki git server`](https://wiki.archlinux.org/title/Git_server)

本机/局域网部署`git server`的几种方法

- 仅需要git远程仓库，终端操作，`git clone/push/pull`
  - 服务器添加`git`用户，创建git bare仓库，ssh连接使用(`git@git-server-ip:/path/to/repo.git`)
- 仅需要网页浏览`git`仓库
  - `cgit`
- 需要协作，定时镜像仓库等
  - `gitea` `gitlab`
- 需要持续集成CI等
  - `gitea+ci` `gitlab`

如果需要更多的功能，使用集成环境可以事半功倍。

以下内容是`git bare仓库+ssh连接`简易git服务器的部署，仅作理解。

### 主机添加git用户

`adduser/useradd`命令添加系统用户git，并设置shell和家目录等，系统用户`uid 100~999`和普通用户`uid 1000~60000`没有技术上的区别，只是在账户用途上不同，如图形登录界面不会显示系统用户。详情参考adduser手册(`man adduser`)和useradd手册(`man useradd`)。

**注意**：arch linux上安装git后会自动添加git用户和git属组。

```sh
# 在打算作为 git server 的主机上执行，之后将该主机称为服务端

# 查看是否有git用户
id git

# 默认添加的系统用户`uid`与`gid`可能不等，强迫症可以指定`gid`和`uid`。
sudo groupadd \
        --system \
        --gid 500 \
        git

sudo useradd \
        --system \
        --uid 500 \
        --gid 500 \
        --shell /bin/bash \
        --create-home \
        git

# 设置/更改git用户密码，`man passwd`
sudo passwd git

# 清除git用户密码
sudo passwd --delete git

# 锁定/解锁git用户密码，用户可以通过ssh密钥登录
sudo passwd --lock git
sudo passwd --unlock git
```

### 创建bare仓库

```sh
# 在服务端执行

# 如果设置了git密码，此时可以`su`到git的身份，否则使用`sudo -u git`以git身份执行命令
su git
sudo -u git

# 创建一个目录，作为仓库的父目录
[sudo -u git] mkdir /dir/as/repo-root

# cd 到仓库的父目录
cd /path/to/repo-root

# 创建一个 bare 仓库
[sudo -u git] git init --bare reponame.git
```

使用git用户创建一个目录，作为仓库的父目录，在该父目录中创建诸如`dotfiles.git`、`repo1.git`、`repo2.git`等仓库作为bare仓库，之后软链到如`/git`以缩短路径，则可使用`git clone git@git-server-ip:/git/repo1.git`克隆所需仓库。

如果需要镜像已有的远程仓库，可以`git clone --bare --mirror git@remote-server /path/to/reponame.git`，详情参考git手册 `man git-clone`。

此时已经可以克隆仓库来验证配置是否正确了

```sh
# 在客户端执行
git clone git@git-server-ip:/path/to/reponame.git

# 修改提交推送
```

### 配置ssh密钥登录

本机/局域网内的客户端有权访问仓库有几种方式：

- git用户的密码
- ssh密钥
- 或者开启匿名访问，详情参考`man git-daemon`

向`git server`的`/home/git/.ssh/authorized_keys`添加其他用户的**公钥**以使其他用户可以**使用密钥认证**后克隆仓库和推送仓库而不用每次输入密码。

**注意**：服务端sshd配置`/etc/ssh/sshd_config`需要开启公钥登录`PubkeyAuthentication yes`

**注意**：要确保ssh使用的文件及其上层所有的文件夹权限正常

- `/home/git`权限为`drwx------`或`drwxr-xr-x`
- `~/.ssh/`权限为`drwx------`
- `~/.ssh/authorized_keys`权限为`-rw-------`

（**不要在家目录`/home/git`上给git属组写权限**，~~`sudo chmod -cv g+w /home/git`~~，家目录权限不对也会导致密钥登录失败！！！）

```sh
# 生成密钥

# 在客户端执行
# `ssh-keygen`生成一对私钥和公钥，私钥:keyname，公钥:keyname.pub
# `-t`指定加密算法，`man ssh-keygen`
ssh-keygen -t ed25519 -f ~/.ssh/keyname -C "comment"
```

```sh
# 上传密钥

# 方法一 通过ssh-copy-id复制**公钥**到服务端

# 在客户端执行
# `-i`指定公钥文件，`man ssh-copy-id`
ssh-copy-id -i ~/.ssh/keyname.pub git@git-server-ip
```

**注意**：如果执行了后面的`禁止git用户通过shell登入`的操作则不能使用ssh-copy-id来上传公钥，可以使用scp从客户端上传公钥`xxx.pub`到服务端的其他用户的某处，然后手动添加公钥`xxx.pub`到`/home/git/.ssh/authorized_keys`，即像`git server`手册里那样在服务端直接编辑`authorized_keys`文件。

```sh
# 上传密钥

# 方法二 通过scp复制**公钥**到服务端，手动添加公钥到`~/.ssh/authorized_keys`

# 在客户端执行
# username是`git-server-ip`上的其他可登录用户
scp ~/.ssh/keyname.pub username@git-server-ip:/tmp

# 在服务端执行
# 要确保ssh使用的文件及文件夹权限正常
[sudo -u git] mkdir /home/git/.ssh
[sudo -u git] chmod 700 /home/git/.ssh
[sudo -u git] touch /home/git/.ssh/authorized_keys
[sudo -u git] chmod 600 /home/git/.ssh/authorized_keys
# 手动添加公钥
cat /tmp/keyname.pub | [sudo -u git] tee -a /home/git/.ssh/authorized_keys
# 删除上传的公钥文件
rm /tmp/keyname.pub
```

```sh
# 测试能否密钥登录

# 在客户端执行
# -T 测试连接但不实际登录 -v 显示ssh连接的详细信息
ssh -Tv git@git-server-ip -i ~/.ssh/keyname
# 如果还需要输入密码就是密钥登录失败，请检查上面的几个注意事项，并参阅ssh手册

# 可以配置~/.ssh/config选择密钥，就不用每次命令行输入密钥路径了，详情参考`man ssh_config`
Host git-server
    Hostname 10.0.0.2
    Port 22
    User git
    PreferredAuthentications publickey,password
    IdentityFile ~/.ssh/keyname
```

此时可以克隆/更新仓库来验证配置是否正确

### 修改git用户shell权限

**禁止**git用户通过shell登入

```sh
# 在服务端执行
cat /etc/shells
which git-shell
sudo -e /etc/shells

# 将git用户的shell设置为`git-shell`，`man chsh`
sudo chsh git -s $(which git-shell) # chsh <username> -s <shell>

# 或者直接编辑/etc/passwd
# 修改`git:x:500:500:Git,,,:/home/git:/bin/git-shell`
```

此时已经不可以`su`到git了。

```sh
# 在服务端执行
su git
Password:
fatal: Interactive git shell is not enabled.
hint: ~/git-shell-commands should exist and have read and execute access.

# 当然客户端也不能以git身份ssh登入了，但可以clone, push
```

**注意**：如果需要将`git server`上的仓库再`push`到另一个远程仓库如`github`，不仅需要`remote`的写权限，也**需要本地的写权限**，但此时已经无法切换到git的身份(`su git`)**在本地**读写仓库(`git pull/push`)或新建仓库(`git init --bare`)了，只能sudo操作(`sudo -u git git push`)，每次`push`到`remote`时都使用sudo不是一个好习惯（让git用户有shell登入权限更不安全），所以有以下几种方法：

- 方法一：通过在服务端配置`git hooks`，使得在客户端提交到服务端后触发`post-update`，执行`git push`到`remote`，详情参考`git hooks`。新建仓库仍然需要`sudo -u git git init --bare repo.git`。
- 方法二：使用集成环境如`gitea`, `gitlab`等。

**注意**：**git添加了目录安全限制**，非仓库所有者无法操作(`dubious owner`)，提示`git config --global --add safe.directory /path/to/repo`，不推荐使用其他用户操作非其所有的仓库（如给仓库添加git属组写权限，然后将其他用户添加到git属组执行操作），容易出现文件权限问题，也不够自动化。

```sh
# 在服务端配置git hooks

# 如果需要服务端自动化push到github/gitlab，需要服务端git用户将其公钥上传至github/gitlab，不然得手动输入用户名密码。

# 在服务端执行
cd /path/to/repo/ # /git/repo.git
cd hooks # /git/repo.git/hooks

[sudo -u git] cp post-update.sample post-update
[sudo -u git] vi post-update
```

**注意**：禁用git用户shell登入后，创建仓库总是需要sudo权限。

```sh
# 新建仓库

# 在服务端执行
cd /path/to/repo-root # /git/
[sudo -u git] mkdir reponame.git
[sudo -u git] git init --bare reponame.git

# 或者已有remote仓库，镜像它
[sudo -u git] git clone --bare --mirror git@github.com:/path/to/reponame.git

# 修改仓库权限（如果仓库所有权不是git）
sudo chown -Rc git:git reponame.git
```

### Web git

- 可以使用`cgit`创建一个简单的web界面浏览git仓库，详情参考`arch wiki cgit`
- 也可以使用`gitea/gitlab`，功能丰富，配置简单，详情参考[`gitea 横向对比`](https://docs.gitea.com/installation/comparison)
