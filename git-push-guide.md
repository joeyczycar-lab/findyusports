# Git 推送问题排查指南

## 常见问题和解决方案

### 1. 网络连接问题

**症状：** `fatal: unable to access 'https://github.com/...': Failed to connect`

**解决方案：**
```bash
# 检查网络连接
ping github.com

# 如果无法访问，可能需要：
# - 检查防火墙设置
# - 配置代理（如果有）
git config --global http.proxy http://proxy.example.com:8080
git config --global https.proxy https://proxy.example.com:8080

# 或者使用 SSH 代替 HTTPS
git remote set-url origin git@github.com:joeyczycar-lab/findyusports.git
```

### 2. 认证问题

**症状：** `fatal: Authentication failed` 或 `fatal: could not read Username`

**解决方案：**
```bash
# 使用 Personal Access Token (推荐)
# 1. 访问 https://github.com/settings/tokens
# 2. 生成新的 token
# 3. 使用 token 作为密码

# 或者配置 Git Credential Manager
git config --global credential.helper manager-core

# Windows 用户可以使用
git config --global credential.helper wincred
```

### 3. 远程分支不同步

**症状：** `error: failed to push some refs` 或 `Updates were rejected`

**解决方案：**
```bash
# 先拉取远程更改
git pull origin master --rebase

# 或者强制推送（谨慎使用）
git push origin master --force
```

### 4. 大文件问题

**症状：** 推送很慢或失败

**解决方案：**
```bash
# 检查是否有大文件
git ls-files | xargs ls -la | sort -k5 -rn | head -10

# 如果 hero-background.jpg 很大，考虑使用 Git LFS
git lfs install
git lfs track "*.jpg"
git add .gitattributes
git add Web/webapp/public/hero-background.jpg
git commit -m "使用 Git LFS 管理图片文件"
```

## 快速推送步骤

```bash
cd F:\Findyu

# 1. 检查状态
git status

# 2. 添加所有更改
git add .

# 3. 提交更改
git commit -m "更新首页背景图片"

# 4. 推送到远程
git push origin master

# 如果失败，尝试：
git push origin master --verbose
```

## 使用批处理脚本

运行 `check-git-push.bat` 来检查 Git 状态和连接问题。




