# 后端 API（NestJS）

## 启动数据库（PostgreSQL + PostGIS）
```powershell
cd F:\网站\Server\api
docker compose up -d
```

默认账号：postgres/postgres，库：venues，端口 5432。

初始化 PostGIS（仅首次）
```sql
CREATE EXTENSION IF NOT EXISTS postgis;
```

## 环境变量 `.env`
```
PORT=4000
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=postgres
DB_NAME=venues

# 或者直接提供 DATABASE_URL（Railway/Render等平台常用）
# DATABASE_URL=postgresql://user:password@host:5432/venues
# 若云数据库要求 SSL，可设置 DB_SSL=true

# 阿里云OSS配置
OSS_REGION=oss-cn-hangzhou
OSS_ACCESS_KEY_ID=your_access_key_id
OSS_ACCESS_KEY_SECRET=your_access_key_secret
OSS_BUCKET=venues-images

# 防盗链配置
OSS_HOTLINK_SECRET=your_hotlink_secret_key

# JWT配置
JWT_SECRET=your_jwt_secret_key
```

## 开发
```powershell
npm.cmd install
npm.cmd run dev
```

## 迁移（TypeORM）
生成迁移（根据实体差异）：
```powershell
npm.cmd run migration:generate
```
运行迁移：
```powershell
npm.cmd run migration:run
```
回滚迁移：
```powershell
npm.cmd run migration:revert
```

## 空间查询说明
- 实体包含 `geom geometry(Point,4326)` 列。
- `GET /venues` 使用 `ST_MakeEnvelope` + `ST_Intersects` 进行矩形范围检索（若 geom 为空则回退到经纬度 between）。


