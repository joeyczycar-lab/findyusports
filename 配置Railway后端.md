# 配置 Railway 后端地址

## 问题

如果你的后端服务部署在 Railway 上，但前端在本地开发时无法连接，需要配置 `NEXT_PUBLIC_API_BASE` 环境变量。

## 解决方案

### 方法 1：使用配置脚本（推荐）

在 PowerShell 中运行：

```powershell
cd F:\Findyu\Web\webapp
.\配置Railway后端.ps1
```

然后输入你的 Railway 后端地址，例如：
- `https://findyusports-production.up.railway.app`
- `https://findyusports-api-production.up.railway.app`

### 方法 2：手动创建 .env.local 文件

在 `Web/webapp` 目录下创建或编辑 `.env.local` 文件：

```env
# 后端 API 地址（Railway）
NEXT_PUBLIC_API_BASE=https://findyusports-production.up.railway.app
```

**注意**：将 `https://findyusports-production.up.railway.app` 替换为你的实际 Railway 后端地址。

### 方法 3：使用现有脚本

如果你已经有 `.env.local` 文件，可以使用：

```powershell
cd F:\Findyu\Web\webapp
.\create-env-local.ps1
```

在提示输入 `NEXT_PUBLIC_API_BASE` 时，输入你的 Railway 后端地址。

## 如何找到 Railway 后端地址

1. 登录 Railway 控制台：https://railway.app
2. 选择你的后端项目
3. 在 "Settings" -> "Networking" 中查看 "Public Domain"
4. 或者查看部署日志中的服务地址

## 配置完成后

1. **重启前端开发服务器**（如果正在运行）：
   - 按 `Ctrl+C` 停止当前服务器
   - 重新运行 `npm run dev`

2. **刷新浏览器页面**

3. **验证连接**：
   - 打开浏览器开发者工具（F12）
   - 查看 Network 标签页
   - 检查 API 请求是否指向正确的 Railway 地址

## 工作原理

- 如果设置了 `NEXT_PUBLIC_API_BASE`，所有 API 路由都会使用这个地址
- 如果没有设置，开发环境会使用 `http://localhost:4000`，生产环境会使用默认的 Railway 地址
- 这样可以在本地开发时灵活选择使用本地后端或 Railway 后端
