# Mac 环境部署指南

## 📋 快速开始（5 分钟）

### 第一步：安装必要软件

#### 1. 安装 Homebrew（Mac 包管理器）

打开 Terminal（终端），运行：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

安装完成后，重启终端或运行：
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

#### 2. 安装 Node.js（推荐使用 nvm）

```bash
# 安装 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 重启终端后，安装 Node.js 20
nvm install 20
nvm use 20
nvm alias default 20
```

验证安装：
```bash
node --version  # 应该显示 v20.x.x
npm --version   # 应该显示版本号
```

#### 3. 安装 Git（如果未安装）

```bash
brew install git
```

配置 Git：
```bash
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
```

---

## 🚀 第二步：克隆项目

### 1. 选择项目存放位置

```bash
# 创建项目目录（可选）
mkdir -p ~/Projects
cd ~/Projects
```

### 2. 克隆 GitHub 仓库

```bash
git clone https://github.com/joeyczycar-lab/findyusports.git
cd findyusports
```

---

## ⚙️ 第三步：配置环境

### 1. 安装前端依赖

```bash
cd Web/webapp
npm install
```

### 2. 配置环境变量

创建 `.env.local` 文件：

```bash
# 在 Web/webapp 目录下
touch .env.local
```

编辑 `.env.local` 文件，填入以下内容：

```env
# 高德地图 API Key（从 Windows 备份的或重新申请）
NEXT_PUBLIC_AMAP_KEY=92a0f4147614a72916eebb75f26784cd

# 后端 API 地址
NEXT_PUBLIC_API_BASE=http://localhost:4000
```

**重要提示**：
- 如果后端在远程服务器，将 `NEXT_PUBLIC_API_BASE` 改为实际地址
- 高德地图 Key 如果失效，需要重新申请

---

## 🎯 第四步：启动开发服务器

### 启动前端

```bash
cd Web/webapp
npm run dev
```

访问：http://localhost:3000

### 启动后端（如果需要本地运行）

```bash
cd ../../Server/api
npm install
npm run dev
```

---

## 🔧 使用自动化脚本（推荐）

项目根目录提供了自动化设置脚本：

```bash
# 给脚本添加执行权限
chmod +x scripts/mac-setup.sh

# 运行脚本
./scripts/mac-setup.sh
```

脚本会自动：
- ✅ 检查并安装 Homebrew
- ✅ 检查并安装 Node.js
- ✅ 检查并安装 Git
- ✅ 安装前端依赖
- ✅ 检查环境变量文件

---

## 📝 完整操作流程示例

```bash
# 1. 安装 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. 安装 nvm 和 Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
# 重启终端后：
nvm install 20
nvm use 20

# 3. 克隆项目
cd ~/Projects
git clone https://github.com/joeyczycar-lab/findyusports.git
cd findyusports

# 4. 安装依赖
cd Web/webapp
npm install

# 5. 创建环境变量文件
cat > .env.local << EOF
NEXT_PUBLIC_AMAP_KEY=92a0f4147614a72916eebb75f26784cd
NEXT_PUBLIC_API_BASE=http://localhost:4000
EOF

# 6. 启动开发服务器
npm run dev
```

---

## 🐛 常见问题解决

### 1. 权限问题

```bash
# 如果 npm install 失败，修复权限
sudo chown -R $(whoami) ~/.npm

# 给脚本添加执行权限
chmod +x scripts/*.sh
```

### 2. 端口被占用

```bash
# 查看端口占用
lsof -i :3000

# 杀死占用端口的进程
kill -9 <PID>
```

### 3. Node.js 版本问题

```bash
# 使用 nvm 切换版本
nvm use 20

# 设置默认版本
nvm alias default 20
```

### 4. 环境变量不生效

确保 `.env.local` 文件在正确位置：
- ✅ `Web/webapp/.env.local`
- ❌ 不在项目根目录

重启开发服务器：
```bash
# 按 Ctrl+C 停止服务器，然后重新启动
npm run dev
```

### 5. Git 推送失败

如果遇到网络问题：

```bash
# 检查远程仓库地址
git remote -v

# 如果需要，配置代理（可选）
git config --global http.proxy http://proxy.example.com:8080
git config --global https.proxy https://proxy.example.com:8080
```

---

## ✅ 验证清单

部署完成后，检查以下项目：

- [ ] Node.js 版本正确（v20.x.x）
- [ ] npm 可以正常使用
- [ ] Git 已配置用户信息
- [ ] 项目已克隆到本地
- [ ] 前端依赖已安装（`node_modules` 存在）
- [ ] `.env.local` 文件已创建并配置
- [ ] 开发服务器可以启动（`npm run dev`）
- [ ] 浏览器可以访问 http://localhost:3000
- [ ] 网站功能正常（导航栏、地图等）

---

## 🎨 推荐工具

### 代码编辑器

- **Cursor**：https://cursor.sh/ （推荐，AI 辅助编程）
- **VS Code**：https://code.visualstudio.com/

### 终端工具

- **iTerm2**：https://iterm2.com/ （比系统终端更好用）
- **Oh My Zsh**：https://ohmyz.sh/ （美化终端）

### Git 工具（可选）

- **GitHub Desktop**：https://desktop.github.com/
- **SourceTree**：https://www.sourcetreeapp.com/

---

## 📞 需要帮助？

如果遇到问题：

1. **检查错误信息**：仔细阅读终端输出的错误信息
2. **查看日志**：检查浏览器控制台和终端日志
3. **验证配置**：确认环境变量和文件路径正确
4. **重启服务**：尝试重启开发服务器
5. **清理缓存**：删除 `node_modules` 和 `.next`，重新安装

```bash
# 清理并重新安装
cd Web/webapp
rm -rf node_modules .next
npm install
npm run dev
```

---

## 🚀 下一步

部署完成后，你可以：

1. **开发新功能**：在 Mac 上继续开发
2. **测试功能**：确保所有功能正常工作
3. **提交代码**：使用 Git 提交并推送到 GitHub
4. **部署到生产**：代码推送到 GitHub 后，Vercel 会自动部署

---

**祝你开发顺利！** 🎉


