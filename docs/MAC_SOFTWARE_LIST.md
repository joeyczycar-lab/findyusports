# Mac 全新系统软件安装清单

## 🔧 必需软件（开发必备）

### 1. Homebrew（Mac 包管理器）
**作用**：用于安装和管理其他软件

**安装命令**：
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**验证**：
```bash
brew --version
```

---

### 2. Node.js（JavaScript 运行时）
**作用**：运行 Next.js 项目

**推荐方式：使用 nvm（Node Version Manager）**

```bash
# 安装 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 重启终端后
nvm install 20
nvm use 20
nvm alias default 20
```

**验证**：
```bash
node --version  # 应该显示 v20.x.x
npm --version   # 应该显示版本号
```

**或者使用 Homebrew 直接安装**：
```bash
brew install node
```

---

### 3. Git（版本控制）
**作用**：克隆和管理代码

**安装**：
```bash
brew install git
```

**配置**：
```bash
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
```

**验证**：
```bash
git --version
```

---

### 4. 代码编辑器

#### Cursor（推荐 - AI 辅助编程）
**下载**：https://cursor.sh/

**特点**：
- AI 辅助编程
- 基于 VS Code
- 智能代码补全

#### VS Code（备选）
**下载**：https://code.visualstudio.com/

**推荐扩展**：
- ESLint
- Prettier
- Tailwind CSS IntelliSense
- GitLens

---

## 🎨 推荐软件（提升开发体验）

### 5. iTerm2（增强终端）
**作用**：比系统终端更好用的终端工具

**安装**：
```bash
brew install --cask iterm2
```

**下载**：https://iterm2.com/

---

### 6. Oh My Zsh（终端美化）
**作用**：美化终端，提供更好的命令提示

**安装**：
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**推荐主题**：
```bash
# 编辑 ~/.zshrc
ZSH_THEME="agnoster"  # 或 "robbyrussell"
```

---

### 7. GitHub Desktop（Git 图形界面，可选）
**作用**：可视化 Git 操作

**安装**：
```bash
brew install --cask github
```

**下载**：https://desktop.github.com/

---

### 8. Postman（API 测试，可选）
**作用**：测试后端 API

**安装**：
```bash
brew install --cask postman
```

**下载**：https://www.postman.com/downloads/

---

## 🌐 浏览器（用于测试）

### 9. Chrome / Edge（推荐）
**作用**：测试网站兼容性

**Chrome**：
```bash
brew install --cask google-chrome
```

**Edge**：
```bash
brew install --cask microsoft-edge
```

---

## 📦 其他实用工具

### 10. Rectangle（窗口管理）
**作用**：快速调整窗口大小和位置

**安装**：
```bash
brew install --cask rectangle
```

---

### 11. The Unarchiver（解压工具）
**作用**：解压各种压缩文件

**安装**：
```bash
brew install --cask the-unarchiver
```

---

### 12. CleanMyMac（系统清理，可选）
**作用**：清理系统垃圾，释放空间

**下载**：https://macpaw.com/cleanmymac

---

## 🚀 一键安装脚本

创建一个脚本，自动安装所有必需软件：

```bash
#!/bin/bash

echo "=========================================="
echo "Mac 开发环境一键安装"
echo "=========================================="

# 1. 安装 Homebrew
if ! command -v brew &> /dev/null; then
    echo "安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. 安装 Git
if ! command -v git &> /dev/null; then
    echo "安装 Git..."
    brew install git
fi

# 3. 安装 Node.js（使用 nvm）
if ! command -v nvm &> /dev/null; then
    echo "安装 nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    echo "请重启终端后运行：nvm install 20"
fi

# 4. 安装 Cursor
echo "安装 Cursor..."
brew install --cask cursor

# 5. 安装 iTerm2
echo "安装 iTerm2..."
brew install --cask iterm2

# 6. 安装 Chrome
echo "安装 Chrome..."
brew install --cask google-chrome

# 7. 安装 GitHub Desktop
echo "安装 GitHub Desktop..."
brew install --cask github

# 8. 安装 Rectangle
echo "安装 Rectangle..."
brew install --cask rectangle

echo ""
echo "=========================================="
echo "✅ 安装完成！"
echo "=========================================="
echo ""
echo "下一步："
echo "1. 重启终端"
echo "2. 运行: nvm install 20"
echo "3. 运行: nvm use 20"
echo "4. 配置 Git:"
echo "   git config --global user.name \"你的名字\""
echo "   git config --global user.email \"你的邮箱\""
```

---

## 📋 安装优先级

### 🔴 必须安装（立即）
1. ✅ Homebrew
2. ✅ Node.js（通过 nvm）
3. ✅ Git
4. ✅ Cursor 或 VS Code

### 🟡 强烈推荐（尽快安装）
5. ✅ iTerm2
6. ✅ Chrome 浏览器
7. ✅ Oh My Zsh

### 🟢 可选安装（按需）
8. ⚪ GitHub Desktop
9. ⚪ Postman
10. ⚪ Rectangle
11. ⚪ 其他工具

---

## ✅ 安装后验证清单

运行以下命令验证安装：

```bash
# 检查 Homebrew
brew --version

# 检查 Node.js
node --version
npm --version

# 检查 Git
git --version
git config --global user.name
git config --global user.email

# 检查 nvm（如果使用）
nvm --version
```

---

## 🎯 快速开始命令

复制以下命令到终端，一键安装所有必需软件：

```bash
# 安装 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装 Git
brew install git

# 安装 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 安装 Cursor
brew install --cask cursor

# 安装 iTerm2
brew install --cask iterm2

# 安装 Chrome
brew install --cask google-chrome

# 配置 Git（替换为你的信息）
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"

# 重启终端后，安装 Node.js
nvm install 20
nvm use 20
nvm alias default 20
```

---

## 💡 提示

1. **首次使用 Homebrew**：可能需要输入 Mac 密码
2. **nvm 安装后**：需要重启终端或运行 `source ~/.zshrc`
3. **Cursor/VS Code**：首次打开可能需要设置权限
4. **Git 配置**：必须配置用户名和邮箱才能提交代码

---

## 📞 遇到问题？

- **Homebrew 安装失败**：检查网络连接，可能需要代理
- **nvm 不生效**：重启终端或运行 `source ~/.zshrc`
- **权限问题**：某些软件需要系统权限，在"系统设置 > 隐私与安全性"中允许

---

**安装完成后，就可以开始部署项目了！** 🎉


