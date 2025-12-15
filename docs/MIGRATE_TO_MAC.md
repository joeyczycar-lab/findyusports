# 从 Windows 迁移到 Mac 指南

## 准备工作

### 1. 备份重要文件

在 Windows 电脑上：

- ✅ 确保所有代码已提交并推送到 GitHub
- ✅ 备份 `.env.local` 文件（包含 API Key 等敏感信息）
- ✅ 记录所有环境变量和配置

### 2. 检查 Git 状态

```bash
cd F:\Findyu
git status
git log --oneline -5  # 查看最近的提交
```

确保所有更改都已提交并推送。

---

## Mac 环境设置

### 1. 安装必要软件

#### 安装 Homebrew（Mac 包管理器）

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 安装 Node.js

```bash
# 使用 Homebrew 安装 Node.js
brew install node

# 或使用 nvm（推荐，可以管理多个 Node.js 版本）
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
nvm use 20
```

#### 安装 Git（如果未安装）

```bash
brew install git
```

#### 安装 VS Code 或 Cursor（代码编辑器）

- VS Code: https://code.visualstudio.com/
- Cursor: https://cursor.sh/

---

## 克隆项目

### 1. 克隆 GitHub 仓库

```bash
# 在 Mac 上选择项目存放位置（例如：~/Projects）
cd ~/Projects

# 克隆仓库
git clone https://github.com/joeyczycar-lab/findyusports.git

# 进入项目目录
cd findyusports
```

### 2. 检查项目结构

```bash
ls -la
# 应该看到：Server/, Web/, docs/, .gitignore 等
```

---

## 配置开发环境

### 1. 前端环境配置

```bash
# 进入前端目录
cd Web/webapp

# 安装依赖
npm install

# 创建环境变量文件
cp .env.local.example .env.local
# 或手动创建 .env.local 文件
```

编辑 `.env.local` 文件，填入你的配置：

```env
# 高德地图 API Key
NEXT_PUBLIC_AMAP_KEY=你的高德地图Key

# 后端 API 地址
NEXT_PUBLIC_API_BASE=http://localhost:4000
```

### 2. 后端环境配置（如果需要本地运行）

```bash
# 进入后端目录
cd ../../Server/api

# 安装依赖
npm install

# 创建 .env 文件
# 复制你在 Windows 上的配置
```

---

## 启动开发服务器

### 前端

```bash
cd Web/webapp
npm run dev
```

访问：http://localhost:3000

### 后端（如果需要）

```bash
cd Server/api
npm run dev
```

---

## 常见问题解决

### 1. 权限问题

如果遇到权限错误：

```bash
# 给脚本添加执行权限
chmod +x scripts/*.sh

# 如果 npm install 失败，可能需要修复权限
sudo chown -R $(whoami) ~/.npm
```

### 2. 路径问题

Mac 使用 `/` 而不是 `\`：

- Windows: `F:\Findyu\Web\webapp`
- Mac: `~/Projects/findyusports/Web/webapp`

### 3. 行尾符问题（CRLF vs LF）

Git 会自动处理，但如果遇到问题：

```bash
# 配置 Git 自动转换
git config core.autocrlf input
```

### 4. 端口被占用

```bash
# 查看端口占用
lsof -i :3000

# 杀死占用端口的进程
kill -9 <PID>
```

### 5. 环境变量不生效

确保 `.env.local` 文件在正确的位置：
- 前端：`Web/webapp/.env.local`
- 后端：`Server/api/.env`

---

## 文件路径差异

### Windows vs Mac

| Windows | Mac |
|---------|-----|
| `F:\Findyu` | `~/Projects/findyusports` |
| `C:\Users\YourName` | `~/` |
| `\` (反斜杠) | `/` (正斜杠) |
| `cmd` 或 `PowerShell` | `Terminal` 或 `zsh` |

### 常用命令对比

| Windows | Mac |
|---------|-----|
| `dir` | `ls` |
| `cd F:\Findyu` | `cd ~/Projects/findyusports` |
| `type file.txt` | `cat file.txt` |
| `copy file1 file2` | `cp file1 file2` |
| `move file1 file2` | `mv file1 file2` |
| `del file.txt` | `rm file.txt` |

---

## 验证安装

### 1. 检查 Node.js

```bash
node --version  # 应该显示 v20.x.x 或更高
npm --version  # 应该显示版本号
```

### 2. 检查 Git

```bash
git --version
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
```

### 3. 测试项目

```bash
cd Web/webapp
npm run dev
```

访问 http://localhost:3000，应该能看到网站。

---

## 重要提示

### ✅ 必须做的

1. **备份 `.env.local` 文件**：包含 API Key 等敏感信息
2. **确保代码已推送到 GitHub**：避免丢失代码
3. **记录所有环境变量**：包括高德地图 Key、数据库配置等
4. **测试所有功能**：确保迁移后一切正常

### ⚠️ 注意事项

1. **文件大小写敏感**：Mac 文件系统区分大小写，Windows 不区分
2. **路径分隔符**：Mac 使用 `/`，Windows 使用 `\`
3. **权限问题**：Mac 对文件权限更严格
4. **行尾符**：Git 会自动处理，但要注意

---

## 快速检查清单

- [ ] 在 Windows 上提交并推送所有代码
- [ ] 备份 `.env.local` 文件
- [ ] 在 Mac 上安装 Node.js
- [ ] 在 Mac 上安装 Git
- [ ] 克隆 GitHub 仓库
- [ ] 安装项目依赖（`npm install`）
- [ ] 配置环境变量（`.env.local`）
- [ ] 启动开发服务器测试
- [ ] 验证所有功能正常

---

## 需要帮助？

如果遇到问题：

1. 检查错误信息
2. 查看项目 README
3. 检查环境变量配置
4. 确认 Node.js 版本（建议 20.x）



