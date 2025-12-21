# Railway 数据库连接配置

## 步骤 1：获取 Railway 数据库连接信息

1. **登录 Railway**
   - 访问 https://railway.app
   - 进入你的项目

2. **找到数据库服务**
   - 点击 PostgreSQL 数据库服务
   - 点击 "Variables" 标签
   - 找到 `DATABASE_URL` 或 `POSTGRES_URL`

3. **复制连接字符串**
   - 格式类似：`postgresql://postgres:password@containers-us-west-xxx.railway.app:5432/railway`

## 步骤 2：配置本地环境变量

在 `Server/api` 目录创建 `.env` 文件：

```bash
cd /Users/Zhuanz/Documents/findyusports/Server/api
cp .env.railway.example .env
```

然后编辑 `.env` 文件，设置：

```env
# Railway 数据库连接（从 Railway 控制台复制）
DATABASE_URL=postgresql://postgres:password@containers-us-west-xxx.railway.app:5432/railway

# Railway 数据库需要 SSL
DB_SSL=true

# 其他配置
PORT=4000
JWT_SECRET=your_jwt_secret_key_here
```

## 步骤 3：初始化 PostGIS（仅首次）

连接到 Railway 数据库并运行：

```sql
CREATE EXTENSION IF NOT EXISTS postgis;
```

你可以使用 Railway CLI：
```bash
railway run psql -c "CREATE EXTENSION IF NOT EXISTS postgis;"
```

或者使用本地 psql：
```bash
psql "你的_DATABASE_URL" -c "CREATE EXTENSION IF NOT EXISTS postgis;"
```

## 步骤 4：运行数据库迁移

```bash
cd /Users/Zhuanz/Documents/findyusports/Server/api
npm run migration:run
```

## 步骤 5：启动后端 API

```bash
npm start
```

## 注意事项

- Railway 数据库通常需要 SSL 连接，所以设置 `DB_SSL=true`
- 如果连接失败，检查防火墙设置
- Railway 的 `DATABASE_URL` 会自动包含所有连接信息
