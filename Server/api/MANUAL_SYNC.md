# 手动同步 Railway 数据到本地

如果自动脚本有问题，可以手动执行以下步骤：

## 步骤 1: 获取 Railway DATABASE_URL

1. 登录 Railway: https://railway.app
2. 进入数据库服务
3. 点击 "Connect" 或 "Variables" 标签页
4. 复制 `DATABASE_URL` 或 `POSTGRES_URL`

## 步骤 2: 检查本地数据库

```cmd
docker ps --filter "name=venues_pg"
```

如果容器未运行，启动它：
```cmd
cd F:\Findyu\Server\api
docker compose up -d
```

## 步骤 3: 从 Railway 导出数据

替换 `你的DATABASE_URL` 为实际的 Railway 连接字符串：

```cmd
cd F:\Findyu\Server\api
docker run --rm -v "%CD%:/backup" postgres:15 pg_dump "你的DATABASE_URL" --data-only --table=venue --table=venue_image --table=review --table=app_user -f /backup/railway_backup.sql
```

**示例：**
```cmd
docker run --rm -v "%CD%:/backup" postgres:15 pg_dump "postgresql://postgres:password@host:port/database" --data-only --table=venue --table=venue_image --table=review --table=app_user -f /backup/railway_backup.sql
```

## 步骤 4: 导入到本地数据库

```cmd
type railway_backup.sql | docker exec -i venues_pg psql -U postgres -d venues
```

## 步骤 5: 验证数据

```cmd
docker exec venues_pg psql -U postgres -d venues -c "SELECT COUNT(*) FROM venue;"
docker exec venues_pg psql -U postgres -d venues -c "SELECT COUNT(*) FROM app_user;"
```

## 常见错误

### 错误 1: "connection refused" 或 "could not connect"

**原因：** Railway 数据库离线或 DATABASE_URL 不正确

**解决：**
1. 检查 Railway 数据库服务是否在线
2. 确认 DATABASE_URL 正确
3. 确保网络连接正常

### 错误 2: "relation does not exist"

**原因：** 本地数据库表不存在

**解决：**
```cmd
cd F:\Findyu\Server\api
npm run migration:run
```

### 错误 3: "duplicate key value"

**原因：** 本地已有相同 ID 的数据

**解决：** 先清空本地数据（会删除所有本地数据）：
```cmd
docker exec venues_pg psql -U postgres -d venues -c "TRUNCATE TABLE review, venue_image, venue, app_user CASCADE;"
```

然后重新导入。



