# Railway 数据库同步到本地指南

## 📋 概述

本指南将帮助你从 Railway 云数据库同步场地数据到本地数据库，这样你就可以在本地开发时使用 Railway 的数据。

---

## 🚀 方法 1：使用自动同步脚本（推荐）

### 前提条件

1. **Docker Desktop 已运行**
2. **本地数据库容器已启动**：`docker compose up -d`
3. **Railway DATABASE_URL**（从 Railway 控制台获取）

### 执行步骤

1. **获取 Railway DATABASE_URL**
   - 登录 Railway：https://railway.app
   - 进入数据库服务
   - 点击 "Connect" 或 "Variables" 标签页
   - 复制 `DATABASE_URL` 或 `POSTGRES_URL`

2. **运行同步脚本**
   ```powershell
   cd F:\Findyu\Server\api
   .\sync-railway-to-local-simple.ps1
   ```

3. **按提示输入 DATABASE_URL**

4. **等待同步完成**

---

## 🔧 方法 2：使用 Railway Query 导出（最简单）

### 步骤

1. **登录 Railway**
   - 访问：https://railway.app
   - 进入你的数据库服务

2. **导出场地数据**
   - 点击 "Query" 标签页
   - 执行以下 SQL：
     ```sql
     SELECT * FROM venue;
     ```
   - 点击 "Download" 或 "Export" 下载 CSV 文件

3. **导出其他表数据**
   重复步骤 2，导出以下表：
   - `venue_image`
   - `review`
   - `app_user`

4. **导入到本地数据库**
   
   由于 CSV 格式需要转换，建议使用方法 1 或方法 3。

---

## 🐳 方法 3：使用 Docker 容器导出（无需安装 PostgreSQL）

### 步骤

1. **获取 Railway DATABASE_URL**

2. **导出数据**
   ```powershell
   cd F:\Findyu\Server\api
   
   # 导出数据到 SQL 文件
   docker run --rm -v "${PWD}:/backup" postgres:15 pg_dump "你的DATABASE_URL" --data-only --table=venue --table=venue_image --table=review --table=app_user -f /backup/railway_data.sql
   ```
   
   替换 `你的DATABASE_URL` 为实际的 Railway 连接字符串。

3. **导入到本地数据库**
   ```powershell
   docker exec -i venues_pg psql -U postgres -d venues < railway_data.sql
   ```

4. **验证数据**
   ```powershell
   docker exec venues_pg psql -U postgres -d venues -c "SELECT COUNT(*) FROM venue;"
   ```

---

## 📝 方法 4：使用 pg_dump（需要安装 PostgreSQL 客户端）

### 前提条件

- 已安装 PostgreSQL 客户端工具（包含 `pg_dump` 和 `psql`）

### 步骤

1. **导出数据**
   ```powershell
   pg_dump "你的DATABASE_URL" --data-only --table=venue --table=venue_image --table=review --table=app_user > railway_data.sql
   ```

2. **导入到本地数据库**
   ```powershell
   docker exec -i venues_pg psql -U postgres -d venues < railway_data.sql
   ```

---

## ⚠️ 注意事项

### 1. 数据冲突处理

如果本地数据库已有数据，导入时可能会遇到：
- **主键冲突**：如果 ID 重复，需要先清空本地数据
- **外键约束**：确保先导入主表（venue, app_user），再导入从表（venue_image, review）

### 2. 清空本地数据（可选）

如果需要完全替换本地数据：

```powershell
# 清空所有数据（⚠️ 会删除本地所有数据）
docker exec venues_pg psql -U postgres -d venues -c "TRUNCATE TABLE review, venue_image, venue, app_user CASCADE;"
```

### 3. 只同步特定表

如果只需要同步场地数据，可以只导出 `venue` 和 `venue_image` 表：

```powershell
docker run --rm -v "${PWD}:/backup" postgres:15 pg_dump "你的DATABASE_URL" --data-only --table=venue --table=venue_image -f /backup/railway_venues.sql
```

---

## 🔄 定期同步

如果需要定期同步数据，可以：

1. **创建定时任务**
   - 使用 Windows 任务计划程序
   - 定期运行同步脚本

2. **手动同步**
   - 每次需要最新数据时运行同步脚本

3. **使用 Git 钩子**
   - 在开发前自动同步数据

---

## ✅ 验证同步结果

同步完成后，验证数据：

```powershell
# 检查场地数量
docker exec venues_pg psql -U postgres -d venues -c "SELECT COUNT(*) FROM venue;"

# 检查用户数量
docker exec venues_pg psql -U postgres -d venues -c "SELECT COUNT(*) FROM app_user;"

# 查看前几条场地数据
docker exec venues_pg psql -U postgres -d venues -c "SELECT id, name, city_code FROM venue LIMIT 5;"
```

---

## 🐛 常见问题

### Q1: 导出失败 "connection refused"

**原因**：Railway DATABASE_URL 不正确或数据库不可访问

**解决**：
1. 检查 DATABASE_URL 是否正确
2. 确认 Railway 数据库服务正在运行
3. 检查网络连接

### Q2: 导入失败 "relation does not exist"

**原因**：本地数据库表不存在

**解决**：
```powershell
# 先运行数据库迁移
cd F:\Findyu\Server\api
npm run migration:run
```

### Q3: 导入失败 "duplicate key value"

**原因**：本地已有相同 ID 的数据

**解决**：
```powershell
# 清空本地数据后重新导入
docker exec venues_pg psql -U postgres -d venues -c "TRUNCATE TABLE review, venue_image, venue, app_user CASCADE;"
```

### Q4: Docker 容器无法访问 Railway

**原因**：Docker 容器网络配置问题

**解决**：
- 确保 Docker Desktop 网络设置正确
- 或使用安装了 PostgreSQL 客户端的主机直接导出

---

## 📚 相关文档

- [本地数据库配置指南](./LOCAL_DATABASE_SETUP.md)
- [Railway 数据库配置指南](./RAILWAY_DATABASE_SETUP.md)

---

**完成同步后，你就可以在本地使用 Railway 的场地数据了！** 🎉



