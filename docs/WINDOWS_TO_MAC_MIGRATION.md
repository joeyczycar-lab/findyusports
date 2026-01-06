# Windows 到 Mac 数据库迁移完整指南

## 📋 迁移步骤概览

1. ✅ 在 Windows 上备份数据库
2. ✅ 传输备份文件到 Mac
3. ✅ 在 Mac 上恢复数据库
4. ✅ 验证数据完整性

---

## 第一步：在 Windows 上备份数据库

### 前置条件

1. **确保 Docker Desktop 已安装并运行**
   - 如果未安装，请先安装 Docker Desktop
   - 打开 Docker Desktop，等待完全启动（系统托盘图标不再闪烁）

2. **检查数据库容器状态**
   ```powershell
   cd F:\Findyu\Server\api
   docker compose ps
   ```

### 方法 1：使用备份脚本（推荐）

```powershell
# 进入 Server 目录
cd F:\Findyu\Server

# 运行 PowerShell 备份脚本
.\backup-database.ps1

# 或者运行批处理脚本
.\backup-database.bat
```

脚本会自动：
- ✅ 检查 Docker 是否运行
- ✅ 启动数据库容器（如果未运行）
- ✅ 创建带时间戳的备份文件（如：`backup_venues_20241118_120000.sql`）

### 方法 2：手动备份

如果脚本不工作，可以手动执行：

```powershell
# 1. 进入 API 目录
cd F:\Findyu\Server\api

# 2. 启动数据库（如果未运行）
docker compose up -d

# 3. 等待数据库完全启动（等待 10-15 秒）
Start-Sleep -Seconds 10

# 4. 创建备份（带时间戳）
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
docker exec venues_pg pg_dump -U postgres venues > "..\backup_venues_$timestamp.sql"

# 或者创建简单名称的备份
docker exec venues_pg pg_dump -U postgres venues > ..\backup_venues.sql
```

### 验证备份文件

备份完成后，检查文件：

```powershell
cd F:\Findyu\Server
Get-ChildItem backup_venues*.sql | Select-Object Name, Length, LastWriteTime
```

**预期结果：**
- 文件大小应该 > 0 KB（通常几 KB 到几 MB，取决于数据量）
- 文件应该包含 SQL 语句（可以用文本编辑器打开查看）

---

## 第二步：传输备份文件到 Mac

选择以下任一方式传输备份文件：

### 方式 1：U 盘/移动硬盘（推荐，适合大文件）

1. 将备份文件复制到 U 盘
   ```powershell
   # 找到备份文件
   cd F:\Findyu\Server
   Copy-Item backup_venues*.sql E:\  # E: 是你的 U 盘盘符
   ```

2. 在 Mac 上插入 U 盘
3. 复制文件到 Mac 项目目录
   ```bash
   # 假设 U 盘挂载在 /Volumes/USB
   cp /Volumes/USB/backup_venues*.sql ~/Desktop/findyusports/Server/
   ```

### 方式 2：网盘（推荐，方便快捷）

**支持的网盘：**
- 百度网盘
- OneDrive
- Google Drive
- Dropbox
- iCloud Drive

**步骤：**
1. 在 Windows 上上传备份文件到网盘
2. 在 Mac 上登录相同账号
3. 下载备份文件到 Mac 的下载文件夹
4. 移动文件到项目目录：
   ```bash
   cp ~/Downloads/backup_venues*.sql ~/Desktop/findyusports/Server/
   ```

### 方式 3：微信文件传输助手（适合小文件）

1. 在 Windows 上登录微信
2. 发送备份文件给"文件传输助手"
3. 在 Mac 上登录微信
4. 从"文件传输助手"下载文件到下载文件夹
5. 移动文件到项目目录：
   ```bash
   cp ~/Downloads/backup_venues*.sql ~/Desktop/findyusports/Server/
   ```

### 方式 4：Git（如果文件不太大，< 100MB）

```powershell
# 在 Windows 上
cd F:\Findyu
git add Server/backup_venues*.sql
git commit -m "Add database backup for Mac migration"
git push origin main
```

然后在 Mac 上：
```bash
cd ~/Desktop/findyusports
git pull origin main
```

**注意：** 如果备份文件很大，建议使用 `.gitignore` 排除，或使用其他传输方式。

### 方式 5：局域网传输（如果两台电脑在同一网络）

**使用 SCP（如果 Mac 开启了 SSH）：**
```powershell
# 在 Windows PowerShell（需要安装 OpenSSH）
scp F:\Findyu\Server\backup_venues*.sql username@mac-ip-address:~/Desktop/findyusports/Server/
```

**或使用共享文件夹：**
1. 在 Windows 上设置共享文件夹
2. 在 Mac 上连接到 Windows 共享
3. 复制文件

---

## 第三步：在 Mac 上恢复数据库

### 前置条件

1. **确保项目已克隆到 Mac**
   ```bash
   cd ~/Desktop
   git clone https://github.com/joeyczycar-lab/findyusports.git
   cd findyusports
   ```

2. **确保 Docker Desktop 已安装并运行**
   - 下载：https://www.docker.com/products/docker-desktop/
   - 打开 Docker Desktop，等待完全启动

3. **确保备份文件在正确位置**
   ```bash
   # 检查备份文件
   ls ~/Desktop/findyusports/Server/backup_venues*.sql
   ```

### 方法 1：使用恢复脚本（推荐）

```bash
# 进入 Server 目录
cd ~/Desktop/findyusports/Server

# 给脚本添加执行权限
chmod +x restore-database.sh

# 运行恢复脚本
./restore-database.sh
```

脚本会自动：
- ✅ 检查 Docker 是否运行
- ✅ 查找备份文件
- ✅ 启动数据库容器
- ✅ 初始化 PostGIS 扩展
- ✅ 恢复数据库

### 方法 2：手动恢复

```bash
# 1. 进入 API 目录
cd ~/Desktop/findyusports/Server/api

# 2. 启动数据库容器
docker compose up -d

# 3. 等待数据库完全启动（等待 10-15 秒）
sleep 10

# 4. 初始化 PostGIS 扩展（首次需要）
docker exec venues_pg psql -U postgres -d venues -c "CREATE EXTENSION IF NOT EXISTS postgis;"

# 5. 恢复数据库
# 替换 backup_venues_20241118_120000.sql 为你的实际文件名
docker exec -i venues_pg psql -U postgres venues < ../backup_venues_20241118_120000.sql

# 或者如果备份文件名是 backup_venues.sql
docker exec -i venues_pg psql -U postgres venues < ../backup_venues.sql
```

### 如果数据库已有数据（需要清空后恢复）

如果 Mac 上的数据库已经有数据，需要先清空：

```bash
# 清空数据库（⚠️ 会删除所有现有数据）
docker exec venues_pg psql -U postgres -d venues -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

# 重新创建 PostGIS 扩展
docker exec venues_pg psql -U postgres -d venues -c "CREATE EXTENSION IF NOT EXISTS postgis;"

# 恢复数据库
docker exec -i venues_pg psql -U postgres venues < ../backup_venues.sql
```

---

## 第四步：验证数据完整性

### 检查表是否恢复成功

```bash
docker exec -it venues_pg psql -U postgres -d venues -c "\dt"
```

**预期输出：** 应该能看到类似这样的表：
- `venue`
- `venue_image`
- `review`
- `user`
- `migrations`（如果使用了 TypeORM 迁移）

### 检查数据条数

```bash
# 检查场地数量
docker exec -it venues_pg psql -U postgres -d venues -c "SELECT COUNT(*) FROM venue;"

# 检查用户数量
docker exec -it venues_pg psql -U postgres -d venues -c "SELECT COUNT(*) FROM app_user;"

# 检查评论数量
docker exec -it venues_pg psql -U postgres -d venues -c "SELECT COUNT(*) FROM review;"
```

### 检查数据内容

```bash
# 查看前几条场地数据
docker exec -it venues_pg psql -U postgres -d venues -c "SELECT id, name, city_code FROM venue LIMIT 5;"
```

---

## 🔧 常见问题排查

### Q1: Windows 上备份时提示 "容器不存在" 或 "容器未运行"

**解决方案：**
```powershell
cd F:\Findyu\Server\api
docker compose up -d
```

等待 10-15 秒后再运行备份命令。

**检查容器状态：**
```powershell
docker ps -a | Select-String venues_pg
```

### Q2: Windows 上备份时提示 "Docker 未运行"

**解决方案：**
1. 打开 Docker Desktop
2. 等待完全启动（系统托盘图标不再闪烁）
3. 验证 Docker 运行：
   ```powershell
   docker ps
   ```

### Q3: Mac 上恢复时提示 "relation already exists"

**原因：** 数据库可能已经有数据。

**解决方案：**
```bash
# 清空数据库后恢复（⚠️ 会丢失现有数据）
docker exec venues_pg psql -U postgres -d venues -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
docker exec venues_pg psql -U postgres -d venues -c "CREATE EXTENSION IF NOT EXISTS postgis;"
docker exec -i venues_pg psql -U postgres venues < ../backup_venues.sql
```

### Q4: Mac 上找不到备份文件

**解决方案：**
```bash
# 查找备份文件
find ~ -name "backup_venues*.sql" -type f

# 或者检查下载文件夹
ls ~/Downloads/backup_venues*.sql

# 或者检查项目目录
ls ~/Desktop/findyusports/Server/backup_venues*.sql
```

### Q5: Mac 上恢复后数据为空

**检查步骤：**

1. **检查备份文件是否完整：**
   ```bash
   # 查看文件大小（应该 > 0）
   ls -lh ~/Desktop/findyusports/Server/backup_venues*.sql
   
   # 查看文件前几行（应该包含 SQL 语句）
   head -20 ~/Desktop/findyusports/Server/backup_venues.sql
   ```

2. **检查恢复过程是否有错误：**
   ```bash
   # 重新恢复并查看详细输出
   docker exec -i venues_pg psql -U postgres venues < ../backup_venues.sql 2>&1 | tee restore.log
   cat restore.log
   ```

3. **检查数据库连接：**
   ```bash
   docker exec venues_pg psql -U postgres -d venues -c "SELECT version();"
   ```

### Q6: 备份文件太大，传输困难

**解决方案：**

1. **压缩备份文件：**
   ```powershell
   # Windows 上压缩
   Compress-Archive -Path F:\Findyu\Server\backup_venues*.sql -DestinationPath F:\Findyu\Server\backup_venues.zip
   ```

2. **传输压缩文件到 Mac**

3. **Mac 上解压：**
   ```bash
   unzip ~/Downloads/backup_venues.zip -d ~/Desktop/findyusports/Server/
   ```

### Q7: PostGIS 扩展相关错误

**解决方案：**
```bash
# 确保 PostGIS 扩展已创建
docker exec venues_pg psql -U postgres -d venues -c "CREATE EXTENSION IF NOT EXISTS postgis;"

# 验证扩展
docker exec venues_pg psql -U postgres -d venues -c "\dx"
```

---

## 📝 快速命令参考

### Windows 备份

```powershell
# 使用脚本
cd F:\Findyu\Server
.\backup-database.ps1

# 手动备份
cd F:\Findyu\Server\api
docker compose up -d
Start-Sleep -Seconds 10
docker exec venues_pg pg_dump -U postgres venues > ..\backup_venues.sql
```

### Mac 恢复

```bash
# 使用脚本
cd ~/Desktop/findyusports/Server
chmod +x restore-database.sh
./restore-database.sh

# 手动恢复
cd ~/Desktop/findyusports/Server/api
docker compose up -d
sleep 10
docker exec venues_pg psql -U postgres -d venues -c "CREATE EXTENSION IF NOT EXISTS postgis;"
docker exec -i venues_pg psql -U postgres venues < ../backup_venues.sql
```

---

## ✅ 完成检查清单

### Windows 端
- [ ] Docker Desktop 已安装并运行
- [ ] 数据库容器已启动
- [ ] 备份文件已创建（`backup_venues*.sql`）
- [ ] 备份文件大小 > 0 KB
- [ ] 备份文件已传输到 Mac

### Mac 端
- [ ] 项目已克隆到 Mac
- [ ] Docker Desktop 已安装并运行
- [ ] 备份文件已在项目目录（`Server/backup_venues*.sql`）
- [ ] 数据库容器已启动
- [ ] 数据库已恢复
- [ ] 数据验证通过（表存在，数据条数正确）

---

## 🎯 迁移后的后续步骤

1. **启动后端服务：**
   ```bash
   cd ~/Desktop/findyusports/Server/api
   npm install
   npm run dev
   ```

2. **验证 API 是否正常工作：**
   ```bash
   curl http://localhost:4000/health
   ```

3. **（可选）删除备份文件：**
   ```bash
   # 确认数据正常后，可以删除备份文件
   rm ~/Desktop/findyusports/Server/backup_venues*.sql
   ```

---

**需要帮助？** 如果遇到问题，请检查：
1. Docker 是否正常运行
2. 数据库容器是否在运行
3. 备份文件是否完整
4. 网络连接是否正常
5. 文件路径是否正确





