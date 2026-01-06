# 数据库备份和迁移指南（Windows → Mac）

## 📋 目录
1. [在 Windows 上备份数据库](#在-windows-上备份数据库)
2. [传输备份文件到 Mac](#传输备份文件到-mac)
3. [在 Mac 上恢复数据库](#在-mac-上恢复数据库)

---

## 在 Windows 上备份数据库

### 方法 1：使用备份脚本（推荐）

1. **打开 PowerShell 或命令提示符**

2. **进入项目目录：**
   ```powershell
   cd F:\Findyu\Server
   ```

3. **运行备份脚本：**
   ```powershell
   .\backup-database.bat
   ```

   脚本会自动：
   - 检查 Docker 是否运行
   - 启动数据库容器（如果未运行）
   - 创建带时间戳的备份文件（如：`backup_venues_20240101_120000.sql`）

### 方法 2：手动备份

如果脚本不工作，可以手动执行：

```powershell
# 1. 进入 API 目录
cd F:\Findyu\Server\api

# 2. 启动数据库（如果未运行）
docker compose up -d

# 3. 等待几秒让数据库完全启动
timeout /t 5

# 4. 创建备份
docker exec venues_pg pg_dump -U postgres venues > ..\backup_venues.sql
```

### 验证备份文件

备份完成后，检查文件是否存在：

```powershell
cd F:\Findyu\Server
dir backup_venues*.sql
```

应该能看到类似这样的文件：
- `backup_venues_20240101_120000.sql`（使用脚本）
- 或 `backup_venues.sql`（手动备份）

---

## 传输备份文件到 Mac

选择以下任一方式：

### 方式 1：U 盘/移动硬盘
1. 将备份文件复制到 U 盘
2. 在 Mac 上插入 U 盘
3. 复制文件到 Mac 桌面或项目目录

### 方式 2：网盘（推荐）
- **百度网盘**、**OneDrive**、**Google Drive**、**Dropbox** 等
- 上传备份文件，然后在 Mac 上下载

### 方式 3：微信文件传输助手
1. 在 Windows 上登录微信
2. 发送备份文件给"文件传输助手"
3. 在 Mac 上登录微信
4. 从"文件传输助手"下载文件

### 方式 4：Git（如果文件不太大）
```powershell
# 在 Windows 上
cd F:\Findyu
git add Server/backup_venues*.sql
git commit -m "Add database backup"
git push origin master
```

然后在 Mac 上：
```bash
cd ~/Desktop/findyusports
git pull origin master
```

---

## 在 Mac 上恢复数据库

### 步骤 1：准备项目

1. **克隆项目（如果还没克隆）：**
   ```bash
   cd ~/Desktop
   git clone https://github.com/joeyczycar-lab/findyusports.git
   cd findyusports
   ```

2. **将备份文件放到项目目录：**
   ```bash
   # 如果备份文件在下载文件夹
   cp ~/Downloads/backup_venues*.sql Server/
   
   # 或者直接拖拽到 Server 目录
   ```

### 步骤 2：启动数据库

```bash
cd Server/api
docker compose up -d
```

等待几秒让数据库完全启动：
```bash
sleep 5
```

### 步骤 3：恢复数据库

#### 方法 1：使用恢复脚本（推荐）

```bash
# 给脚本添加执行权限
chmod +x ../restore-database.sh

# 运行恢复脚本
../restore-database.sh
```

#### 方法 2：手动恢复

```bash
# 1. 确保数据库容器运行
docker compose ps

# 2. 初始化 PostGIS 扩展（首次需要）
docker exec venues_pg psql -U postgres -d venues -c "CREATE EXTENSION IF NOT EXISTS postgis;"

# 3. 恢复数据库
# 替换 backup_venues_20240101_120000.sql 为你的实际文件名
docker exec -i venues_pg psql -U postgres venues < ../backup_venues_20240101_120000.sql
```

### 步骤 4：验证数据

检查表是否恢复成功：

```bash
docker exec -it venues_pg psql -U postgres -d venues -c "\dt"
```

应该能看到类似这样的表：
- `venue`
- `venue_image`
- `review`
- `user`

查看数据条数：

```bash
docker exec -it venues_pg psql -U postgres -d venues -c "SELECT COUNT(*) FROM venue;"
```

---

## 🔧 常见问题

### Q1: 备份时提示 "容器不存在" 或 "容器未运行"

**解决方案：**
```powershell
cd F:\Findyu\Server\api
docker compose up -d
```

等待 10-15 秒后再运行备份命令。

### Q2: 恢复时提示 "relation already exists"

**解决方案：**
数据库可能已经有数据。可以选择：

1. **清空数据库后恢复（会丢失现有数据）：**
   ```bash
   docker exec venues_pg psql -U postgres -d venues -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
   docker exec -i venues_pg psql -U postgres venues < backup_venues.sql
   ```

2. **或者保留现有数据，只恢复缺失的表**

### Q3: Mac 上找不到备份文件

**解决方案：**
```bash
# 查找备份文件
find ~ -name "backup_venues*.sql" -type f

# 或者检查下载文件夹
ls ~/Downloads/backup_venues*.sql
```

### Q4: 恢复后数据为空

**检查：**
1. 备份文件是否完整（文件大小应该 > 0）
2. 恢复过程中是否有错误信息
3. 数据库连接是否正确

**重新恢复：**
```bash
# 查看恢复日志
docker exec -i venues_pg psql -U postgres venues < backup_venues.sql 2>&1 | tee restore.log
```

---

## 📝 快速命令参考

### Windows 备份
```powershell
cd F:\Findyu\Server
.\backup-database.bat
```

### Mac 恢复
```bash
cd ~/Desktop/findyusports/Server
chmod +x restore-database.sh
./restore-database.sh
```

---

## ✅ 完成检查清单

- [ ] Windows 上备份文件已创建
- [ ] 备份文件已传输到 Mac
- [ ] Mac 上项目已克隆
- [ ] Mac 上 Docker 已安装并运行
- [ ] Mac 上数据库容器已启动
- [ ] Mac 上数据库已恢复
- [ ] Mac 上数据验证通过

---

**需要帮助？** 如果遇到问题，请检查：
1. Docker 是否正常运行
2. 数据库容器是否在运行
3. 备份文件是否完整
4. 网络连接是否正常












