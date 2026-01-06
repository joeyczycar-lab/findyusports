# 配置本地数据库指南

## 📋 前置要求

要让网页使用本地数据库，需要：

1. **安装 Docker Desktop**（必须）
2. **配置 .env 文件**（使用本地数据库配置）
3. **启动数据库容器**
4. **运行数据库迁移**
5. **启动后端服务**

---

## 第一步：安装 Docker Desktop

### 如果还没有安装 Docker

1. **下载 Docker Desktop**
   - 访问：https://www.docker.com/products/docker-desktop/
   - 点击 "Download for Windows"
   - 下载安装包（约 500MB）

2. **安装 Docker Desktop**
   - 运行安装包
   - 按照提示完成安装
   - **安装完成后重启电脑**（重要！）

3. **启动 Docker Desktop**
   - 打开 Docker Desktop 应用
   - 等待完全启动（系统托盘图标不再闪烁）

4. **验证安装**
   ```powershell
   docker --version
   docker ps
   ```
   如果命令能正常运行，说明安装成功。

---

## 第二步：配置 .env 文件

### 方法 1：手动创建（推荐）

在 `Server/api` 目录下创建 `.env` 文件：

```powershell
cd F:\Findyu\Server\api
notepad .env
```

复制以下内容到 `.env` 文件：

```env
# 服务器配置
PORT=4000

# 本地数据库配置（Docker）
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=postgres
DB_NAME=venues

# 重要：如果之前配置了 Railway，请注释掉或删除 DATABASE_URL
# DATABASE_URL=postgresql://...
# DB_SSL=true

# JWT 配置
JWT_SECRET=your_random_secret_key_here_change_this

# 阿里云OSS配置（可选）
# OSS_REGION=oss-cn-hangzhou
# OSS_ACCESS_KEY_ID=your_access_key_id
# OSS_ACCESS_KEY_SECRET=your_access_key_secret
# OSS_BUCKET=venues-images
```

**重要提示：**
- 如果 `.env` 文件中有 `DATABASE_URL`，请**注释掉或删除**它
- 确保 `DB_HOST=localhost` 和 `DB_PORT=5432` 已设置
- `JWT_SECRET` 可以生成一个随机字符串

### 方法 2：使用 PowerShell 创建

```powershell
cd F:\Findyu\Server\api

@"
PORT=4000
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=postgres
DB_NAME=venues
JWT_SECRET=local_dev_secret_key_$(Get-Random)
"@ | Out-File -FilePath .env -Encoding utf8
```

---

## 第三步：启动数据库容器

```powershell
cd F:\Findyu\Server\api
docker compose up -d
```

**预期输出：**
```
[+] Running 2/2
 ✔ Container venues_pg  Started
```

**验证容器运行：**
```powershell
docker ps
```

应该能看到 `venues_pg` 容器正在运行。

---

## 第四步：初始化 PostGIS 扩展

```powershell
docker exec venues_pg psql -U postgres -d venues -c "CREATE EXTENSION IF NOT EXISTS postgis;"
```

**预期输出：**
```
CREATE EXTENSION
```

---

## 第五步：运行数据库迁移

```powershell
cd F:\Findyu\Server\api
npm run migration:run
```

**预期输出：**
```
Migration InitialSchema1690000000000 has been executed successfully.
Migration InitPostgisGeomIndex1700000000000 has been executed successfully.
```

---

## 第六步：启动后端服务

```powershell
cd F:\Findyu\Server\api
npm run dev
```

**预期输出：**
```
API running on http://localhost:4000
```

---

## 第七步：配置前端连接本地后端

前端默认已经配置为连接 `http://localhost:4000`，无需额外配置。

如果需要确认，检查 `Web/webapp/.env.local` 文件：

```env
NEXT_PUBLIC_API_BASE=http://localhost:4000
```

如果没有这个文件，前端会使用默认值 `http://localhost:4000`。

---

## ✅ 验证配置

### 1. 检查数据库连接

在浏览器访问：
```
http://localhost:4000/health
```

或者使用 curl：
```powershell
curl http://localhost:4000/health
```

### 2. 测试注册接口

在浏览器访问：
```
http://localhost:4000/auth/register
```

或者使用 curl 测试：
```powershell
curl -X POST http://localhost:4000/auth/register `
  -H "Content-Type: application/json" `
  -d '{\"phone\":\"13800000001\",\"password\":\"123456\",\"nickname\":\"测试用户\"}'
```

### 3. 在前端页面测试

1. 启动前端服务：
   ```powershell
   cd F:\Findyu\Web\webapp
   npm run dev
   ```

2. 访问：http://localhost:3000

3. 尝试注册/登录，应该能正常连接到本地数据库。

---

## 🔧 常见问题

### Q1: Docker 命令找不到

**错误：** `无法将"docker"项识别为 cmdlet...`

**解决方案：**
1. 确保已安装 Docker Desktop
2. 重启电脑
3. 打开 Docker Desktop 应用
4. 等待完全启动后再运行命令

### Q2: 数据库连接失败

**错误：** `connect ECONNREFUSED 127.0.0.1:5432`

**解决方案：**
1. 检查 Docker 容器是否运行：
   ```powershell
   docker ps
   ```
2. 如果没有运行，启动容器：
   ```powershell
   docker compose up -d
   ```
3. 检查 `.env` 文件中的 `DB_HOST` 是否为 `localhost`

### Q3: 迁移失败

**错误：** `relation already exists`

**原因：** 数据库表已经存在

**解决方案：**
```powershell
# 如果需要重置数据库（⚠️ 会删除所有数据）
npm run migration:revert
npm run migration:run
```

### Q4: 前端仍然连接 Railway

**原因：** `.env` 文件中还有 `DATABASE_URL`

**解决方案：**
1. 打开 `Server/api/.env` 文件
2. 注释掉或删除 `DATABASE_URL` 和 `DB_SSL` 行：
   ```env
   # DATABASE_URL=postgresql://...
   # DB_SSL=true
   ```
3. 确保有本地数据库配置：
   ```env
   DB_HOST=localhost
   DB_PORT=5432
   DB_USER=postgres
   DB_PASS=postgres
   DB_NAME=venues
   ```
4. 重启后端服务

---

## 📝 快速命令参考

### 完整配置流程

```powershell
# 1. 进入 API 目录
cd F:\Findyu\Server\api

# 2. 创建 .env 文件（如果还没有）
# 编辑 .env，确保使用本地数据库配置

# 3. 启动数据库
docker compose up -d

# 4. 初始化 PostGIS
docker exec venues_pg psql -U postgres -d venues -c "CREATE EXTENSION IF NOT EXISTS postgis;"

# 5. 运行迁移
npm run migration:run

# 6. 启动后端
npm run dev
```

### 日常使用

```powershell
# 启动数据库
docker compose up -d

# 停止数据库
docker compose down

# 查看数据库日志
docker logs venues_pg

# 重启数据库
docker restart venues_pg
```

---

## ✅ 配置检查清单

完成配置后，请确认：

- [ ] Docker Desktop 已安装并运行
- [ ] `.env` 文件已创建
- [ ] `.env` 文件中使用本地数据库配置（`DB_HOST=localhost`）
- [ ] `.env` 文件中没有 `DATABASE_URL`（或已注释）
- [ ] 数据库容器已启动（`docker ps` 能看到 `venues_pg`）
- [ ] PostGIS 扩展已初始化
- [ ] 数据库迁移已运行
- [ ] 后端服务已启动（`http://localhost:4000` 可访问）
- [ ] 前端可以正常注册/登录

---

**配置完成后，你的网页就会使用本地数据库了！** 🎉





