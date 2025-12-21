# 初始化 PostGIS 扩展

## 方法 1：使用 Railway Web 界面（最简单）

1. 访问 Railway：https://railway.app
2. 进入项目 → 点击 "Postgres" 服务
3. 点击 "数据库" 标签
4. 点击 "扩展"（Extensions）子标签
5. 点击 "添加扩展"（Add Extension）
6. 搜索并添加 "postgis"
7. 点击 "保存"

## 方法 2：使用 Railway CLI

```bash
railway run psql -c "CREATE EXTENSION IF NOT EXISTS postgis;"
```

## 方法 3：安装 PostgreSQL 客户端后使用 psql

```bash
# 安装 PostgreSQL 客户端
brew install postgresql

# 连接并创建扩展
psql "postgresql://postgres:wzQlXXtAwygbvCXsNkDuWxqTnYoimUtE@yamanote.proxy.rlwy.net:29122/railway" -c "CREATE EXTENSION IF NOT EXISTS postgis;"
```
