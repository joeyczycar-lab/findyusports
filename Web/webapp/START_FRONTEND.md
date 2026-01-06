# 启动前端服务指南

## 🚀 快速启动

### 方法 1：使用批处理脚本（最简单）

1. **打开文件资源管理器**
2. **进入目录**：`F:\Findyu\Web\webapp`
3. **双击运行**：`启动开发服务器.bat` 或 `start-dev.bat`

### 方法 2：使用命令行

打开 PowerShell 或命令提示符：

```cmd
cd F:\Findyu\Web\webapp
npm run dev
```

---

## ✅ 启动成功的标志

看到以下信息说明启动成功：

```
▲ Next.js 14.2.5
- Local:        http://localhost:3000
✓ Ready in X.Xs
```

---

## 🌐 访问网站

启动成功后，在浏览器访问：

- **主页**：http://localhost:3000
- **地图页面**：http://localhost:3000/map
- **添加场地**：http://localhost:3000/admin/add-venue

---

## ⚠️ 常见问题

### 问题 1：端口 3000 已被占用

**错误信息**：`Port 3000 is already in use`

**解决方案**：
1. 关闭占用 3000 端口的程序
2. 或使用其他端口：
   ```cmd
   npm run dev -- -p 3001
   ```

### 问题 2：npm 命令找不到

**错误信息**：`npm: 无法识别`

**解决方案**：
1. 安装 Node.js：https://nodejs.org/
2. 重启命令行窗口

### 问题 3：模块未安装

**错误信息**：`Cannot find module`

**解决方案**：
```cmd
cd F:\Findyu\Web\webapp
npm install
```

---

## 🛑 停止服务

在运行 `npm run dev` 的窗口中，按 `Ctrl + C`

---

## 📋 完整开发环境启动流程

### 1. 启动 Docker Desktop（如果未运行）

### 2. 启动数据库容器（如果未运行）

```cmd
cd F:\Findyu\Server\api
docker compose up -d
```

### 3. 启动后端服务

```cmd
cd F:\Findyu\Server\api
npm run dev
```

**后端运行在**：http://localhost:4000

### 4. 启动前端服务（新开一个终端窗口）

```cmd
cd F:\Findyu\Web\webapp
npm run dev
```

**前端运行在**：http://localhost:3000

---

## ✅ 验证配置

### 检查后端是否运行

访问：http://localhost:4000/venues

### 检查前端是否运行

访问：http://localhost:3000

### 测试注册功能

1. 打开：http://localhost:3000
2. 点击"登录"或"注册"
3. 尝试注册新用户

---

**现在可以开始使用网站了！** 🎉



