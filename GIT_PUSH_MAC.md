# Mac 上 Git 推送指南

## ✅ 已完成

- ✅ 代码已提交到本地仓库
- ✅ Git 用户信息已配置
- ✅ 创建了 `.env.local.example` 模板文件

## 📝 待完成：推送到 GitHub

代码已提交到本地，但推送到 GitHub 需要认证。

### 方法 1：使用 Personal Access Token（推荐）

1. **生成 Token**：
   - 访问：https://github.com/settings/tokens
   - 点击 "Generate new token" → "Generate new token (classic)"
   - 勾选 `repo` 权限
   - 生成并复制 token

2. **推送代码**：
   ```bash
   cd ~/Documents/findyusports
   git push origin master
   ```
   - 用户名：输入你的 GitHub 用户名
   - 密码：输入刚才生成的 token（不是 GitHub 密码）

### 方法 2：配置 SSH 密钥（一次性设置）

1. **生成 SSH 密钥**（如果还没有）：
   ```bash
   ssh-keygen -t ed25519 -C "262966441@qq.com"
   ```

2. **添加 SSH 密钥到 GitHub**：
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
   - 复制输出的公钥
   - 访问：https://github.com/settings/keys
   - 点击 "New SSH key"
   - 粘贴公钥并保存

3. **切换远程地址为 SSH**：
   ```bash
   cd ~/Documents/findyusports
   git remote set-url origin git@github.com:joeyczycar-lab/findyusports.git
   git push origin master
   ```

### 方法 3：使用 GitHub CLI

```bash
# 安装 GitHub CLI
brew install gh

# 登录
gh auth login

# 推送
git push origin master
```

## 📊 当前提交状态

```bash
# 查看提交历史
git log --oneline -3

# 查看未推送的提交
git log origin/master..HEAD
```

## 🔧 如果推送失败

### 检查网络连接
```bash
ping github.com
```

### 检查远程仓库
```bash
git remote -v
```

### 强制推送（谨慎使用）
```bash
git push origin master --force
```

---

**提示**：代码已安全保存在本地 Git 仓库中，即使暂时无法推送到 GitHub，也不会丢失。

