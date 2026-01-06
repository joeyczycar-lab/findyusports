# Docker Desktop 重新安装指南

## 情况说明

如果 Docker Desktop 被卸载了，但数据可能还在 Docker volume 中。重新安装后通常可以恢复数据。

---

## 数据库位置信息

### 数据库存储位置

你的数据库数据存储在以下位置：

**主要数据文件：**
- **路径**：`C:\Users\Administrator\AppData\Local\Docker\wsl\disk\docker_data.vhdx`
- **大小**：约 2.38 GB
- **最后修改时间**：2025年11月18日 04:58:24
- **创建时间**：2025年11月17日 17:53:21

**Docker 配置信息：**
- Volume 名称：`pgdata`（在 docker-compose.yml 中定义）
- 容器内路径：`/var/lib/postgresql/data`
- 容器名称：`venues_pg`
- 数据库名：`venues`
- 用户名：`postgres`
- 密码：`postgres`

**其他相关目录：**
- Docker 主目录：`C:\Users\Administrator\AppData\Local\Docker`
- WSL 数据目录：`C:\Users\Administrator\AppData\Local\Docker\wsl`
- WSL 主系统：`C:\Users\Administrator\AppData\Local\Docker\wsl\main\ext4.vhdx` (100 MB)

### 如何验证数据是否还在

```powershell
# 检查数据文件是否存在
Test-Path "C:\Users\Administrator\AppData\Local\Docker\wsl\disk\docker_data.vhdx"

# 查看文件信息
Get-Item "C:\Users\Administrator\AppData\Local\Docker\wsl\disk\docker_data.vhdx" | Select-Object FullName, Length, LastWriteTime
```

**注意**：`.vhdx` 文件是虚拟磁盘文件，包含了所有 Docker volume 的数据。只要这个文件还在，重新安装 Docker Desktop 后，数据应该可以恢复。

---

## 步骤 1：检查数据是否还在

运行检查脚本：

```powershell
cd F:\Findyu\Server
.\检查Docker数据.ps1
```

或者手动检查：

```powershell
# 检查 Docker 数据目录
dir "$env:LOCALAPPDATA\Docker"
dir "$env:USERPROFILE\AppData\Local\Docker"
```

如果找到数据目录，说明数据还在，可以继续。

---

## 步骤 2：重新安装 Docker Desktop

### 下载
1. 访问：https://www.docker.com/products/docker-desktop/
2. 点击 "Download for Windows"
3. 下载安装包（约 500MB）

### 安装
1. 运行安装包
2. 按照提示完成安装
3. 安装完成后重启电脑（推荐）

### 启动
1. 打开 Docker Desktop
2. 等待完全启动（系统托盘图标不再闪烁）
3. 可能需要登录 Docker Hub 账号（可选）

---

## 步骤 3：验证数据是否恢复

安装完成后，运行：

```powershell
cd F:\Findyu\Server\api
docker compose up -d
docker ps -a
```

如果看到 `venues_pg` 容器，说明数据还在。

---

## 步骤 4：备份数据库

数据恢复后，立即备份：

```powershell
cd F:\Findyu\Server\api
docker compose up -d
Start-Sleep -Seconds 10
docker exec venues_pg pg_dump -U postgres venues > ..\backup_venues.sql
```

---

## 如果数据丢失了怎么办？

### 方案 A：从 Railway 云数据库备份（如果有）

如果你之前部署到 Railway，可以从云端备份：

1. 登录 Railway：https://railway.app
2. 找到你的项目
3. 点击数据库服务
4. 在 "Data" 标签页点击 "Download" 下载备份

### 方案 B：重新初始化数据库

如果数据不重要或可以重新创建：

```powershell
cd F:\Findyu\Server\api
docker compose up -d
Start-Sleep -Seconds 10
docker exec venues_pg psql -U postgres -d venues -c "CREATE EXTENSION IF NOT EXISTS postgis;"
cd ..
cd ..
npm run migration:run
npm run seed
```

---

## 常见问题

### Q: 重新安装后容器不见了？
A: 运行 `docker compose up -d` 重新创建容器，数据应该还在 volume 中。

### Q: 如何确认数据是否还在？
A: 检查 Docker volume：
```powershell
docker volume ls
docker volume inspect findyu_pgdata
```

### Q: 备份文件在哪里？
A: 备份成功后，文件在：`F:\Findyu\Server\backup_venues.sql`

---

## 推荐操作顺序

1. ✅ 检查数据是否还在
2. ✅ 重新安装 Docker Desktop
3. ✅ 启动数据库容器
4. ✅ **立即备份数据库**（重要！）
5. ✅ 将备份文件复制到 Mac

---

## 📦 迁移到 Mac

如果需要将数据库迁移到 Mac，请参考：
- **[Windows 到 Mac 数据库迁移完整指南](./WINDOWS_TO_MAC_MIGRATION.md)** - 详细的迁移步骤和故障排查



