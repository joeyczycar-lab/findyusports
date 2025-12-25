# Git 快速推送指南

## 方法 1: 使用 Shell 脚本（推荐）

在项目根目录运行：

```bash
# 使用默认提交信息（带时间戳）
./git-push.sh

# 或指定自定义提交信息
./git-push.sh "fix: 修复了某个bug"
```

## 方法 2: 使用 npm 脚本

在 `Server/api` 目录下运行：

```bash
# 使用默认提交信息
npm run git:push:auto

# 或使用自定义提交信息（需要修改脚本或直接使用 git-push.sh）
npm run git:push
```

## 方法 3: 使用 Git Alias（一次性设置）

在终端运行以下命令设置 git alias：

```bash
git config --global alias.pushall '!f() { git add -A && git commit -m "${1:-Update: $(date +\"%Y-%m-%d %H:%M:%S\")}" && git push; }; f'
```

之后就可以在任何 git 仓库中使用：

```bash
# 使用默认提交信息
git pushall

# 或指定自定义提交信息
git pushall "fix: 修复了某个bug"
```

## 方法 4: 手动命令（传统方式）

```bash
git add -A
git commit -m "你的提交信息"
git push
```

## 注意事项

- 脚本会自动检查是否有未提交的更改
- 如果没有更改，脚本会直接退出，不会创建空提交
- 所有更改（包括删除的文件）都会被自动添加
- 确保你有推送权限到远程仓库

