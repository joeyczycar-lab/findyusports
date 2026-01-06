# 阿里云 RDS 数据库备份指南

## 概述

如果你的数据库在阿里云 RDS（PostgreSQL），可以通过以下方式备份：

---

## 方法一：使用 pg_dump 工具（推荐）

### 前置要求

1. **安装 PostgreSQL 客户端工具**
   - 下载：https://www.postgresql.org/download/windows/
   - 安装时选择 "Command Line Tools"
   - 或者只安装客户端工具（不需要完整数据库）

2. **确保数据库允许外网访问**
   - 登录阿里云控制台
   - 进入 RDS 实例 → 数据安全性 → 白名单设置
   - 添加你的 IP 地址（或使用 0.0.0.0/0 允许所有 IP，不推荐）

### 使用自动化脚本备份

运行备份脚本：

```powershell
cd F:\Findyu\Server
.\备份阿里云数据库.ps1
```

脚本会：
1. 自动检查是否安装了 pg_dump
2. 尝试从 `.env` 文件读取数据库配置
3. 如果找不到配置，会提示你手动输入
4. 创建备份文件

### 手动备份命令

如果脚本不工作，可以手动执行：

```powershell
# 设置密码环境变量
$env:PGPASSWORD = "你的数据库密码"

# 执行备份
pg_dump -h rm-xxxxx.pg.rds.aliyuncs.com -p 5432 -U your_username -d venues -F p -f backup_venues.sql

# 清除密码
Remove-Item Env:\PGPASSWORD
```

**参数说明：**
- `-h`: 数据库主机地址（阿里云 RDS 连接地址）
- `-p`: 端口（通常是 5432）
- `-U`: 数据库用户名
- `-d`: 数据库名
- `-F p`: 输出格式为纯文本 SQL
- `-f`: 输出文件路径

---

## 方法二：使用 Docker 备份（无需安装 PostgreSQL）

如果你不想安装 PostgreSQL 客户端，可以使用 Docker：

### 1. 安装 Docker Desktop

下载：https://www.docker.com/products/docker-desktop/

### 2. 使用 PostgreSQL 官方镜像备份

```powershell
# 设置密码环境变量
$env:PGPASSWORD = "你的数据库密码"

# 使用 Docker 运行 pg_dump
docker run --rm -e PGPASSWORD=$env:PGPASSWORD postgres:15 pg_dump -h rm-xxxxx.pg.rds.aliyuncs.com -p 5432 -U your_username -d venues > backup_venues.sql

# 清除密码
Remove-Item Env:\PGPASSWORD
```

---

## 方法三：从阿里云控制台下载备份

### 1. 登录阿里云控制台

访问：https://rdsnext.console.aliyun.com/

### 2. 找到你的 RDS 实例

1. 进入 "云数据库 RDS PostgreSQL"
2. 找到你的数据库实例
3. 点击实例名称进入详情页

### 3. 创建备份

1. 点击左侧菜单 "备份恢复"
2. 点击 "创建备份"
3. 选择备份类型（建议选择"全量备份"）
4. 等待备份完成

### 4. 下载备份

1. 在备份列表中，找到刚创建的备份
2. 点击 "下载"
3. 选择下载方式（内网下载或外网下载）
4. 下载完成后解压，得到 SQL 文件

---

## 获取数据库连接信息

### 从阿里云控制台获取

1. 登录阿里云控制台
2. 进入 RDS 实例详情页
3. 查看 "连接信息"：
   - **连接地址**：例如 `rm-xxxxx.pg.rds.aliyuncs.com`
   - **端口**：通常是 `5432`
   - **数据库名**：你创建的数据库名
   - **用户名**：通常是创建实例时设置的用户名

### 从项目配置获取

检查 `Server/api/.env` 文件：

```env
DB_HOST=rm-xxxxx.pg.rds.aliyuncs.com
DB_PORT=5432
DB_USER=your_username
DB_PASS=your_password
DB_NAME=venues
```

或者：

```env
DATABASE_URL=postgresql://user:password@rm-xxxxx.pg.rds.aliyuncs.com:5432/venues
```

---

## 常见问题

### Q: 连接超时或拒绝连接

**原因：** 数据库白名单未添加你的 IP

**解决：**
1. 登录阿里云控制台
2. 进入 RDS 实例 → 数据安全性 → 白名单设置
3. 添加你的公网 IP（可以在 https://www.ip138.com/ 查看）
4. 或者临时添加 `0.0.0.0/0`（允许所有 IP，不安全，仅用于测试）

### Q: 认证失败

**原因：** 用户名或密码错误

**解决：**
1. 检查 `.env` 文件中的用户名和密码
2. 或者在阿里云控制台重置密码

### Q: 找不到 pg_dump 命令

**解决：**
1. 安装 PostgreSQL 客户端工具（见方法一）
2. 或者使用 Docker 方式备份（见方法二）
3. 或者从阿里云控制台下载备份（见方法三）

### Q: 备份文件很大

**原因：** 数据库数据量大

**解决：**
- 这是正常的，备份文件会包含所有数据
- 可以使用压缩备份：添加 `-F c` 参数（自定义格式，可压缩）

---

## 备份后操作

备份成功后，文件会在：`F:\Findyu\Server\backup_venues_aliyun_YYYYMMDD_HHMMSS.sql`

### 1. 验证备份文件

```powershell
# 查看文件大小
dir backup_venues_aliyun_*.sql

# 查看文件前几行（确认是有效的 SQL）
Get-Content backup_venues_aliyun_*.sql -TotalCount 20
```

### 2. 复制到 Mac

- 使用 U 盘
- 使用网盘（百度网盘、阿里云盘等）
- 使用微信文件传输助手
- 使用 AirDrop（如果有 Mac 在同一网络）

### 3. 在 Mac 上恢复

参考：`docs/DATABASE_BACKUP_MIGRATION.md`

---

## 推荐方法

- **最简单**：从阿里云控制台下载备份（方法三）
- **最灵活**：使用 pg_dump 工具（方法一）
- **无需安装**：使用 Docker（方法二）

选择最适合你的方法即可！











