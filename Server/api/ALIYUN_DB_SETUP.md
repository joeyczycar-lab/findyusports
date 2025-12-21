# 阿里云数据库连接配置指南

## 方式 1：使用配置脚本（推荐）

运行交互式配置脚本：
```bash
cd /Users/Zhuanz/Documents/findyusports/Server/api
./setup-aliyun-db.sh
```

脚本会引导你输入：
- 数据库主机地址
- 数据库端口（默认 5432）
- 数据库用户名
- 数据库密码
- 数据库名称
- JWT_SECRET（可选，会自动生成）

## 方式 2：手动创建 .env 文件

在 `Server/api` 目录创建 `.env` 文件：

```env
# 阿里云数据库配置
DB_HOST=your-db-host.rds.aliyuncs.com
DB_PORT=5432
DB_USER=your_username
DB_PASS=your_password
DB_NAME=your_database_name

# 如果阿里云数据库需要 SSL，取消下面的注释
# DB_SSL=true

# 其他配置
PORT=4000

# JWT配置
JWT_SECRET=your_jwt_secret_key_here

# 阿里云OSS配置（如果需要图片上传功能）
# OSS_REGION=oss-cn-hangzhou
# OSS_ACCESS_KEY_ID=your_access_key_id
# OSS_ACCESS_KEY_SECRET=your_access_key_secret
# OSS_BUCKET=venues-images
# OSS_HOTLINK_SECRET=your_hotlink_secret_key
```

## 获取阿里云数据库信息

1. **登录阿里云控制台**
   - 访问 https://ecs.console.aliyun.com 或 https://rds.console.aliyun.com
   - 进入 RDS PostgreSQL 实例

2. **查找连接信息**
   - **内网地址**：用于同一地域的 ECS 访问
   - **外网地址**：用于本地开发访问（需要开启外网访问）
   - **端口**：通常是 5432
   - **数据库账号**：创建数据库时设置的用户名
   - **数据库密码**：创建数据库时设置的密码
   - **数据库名称**：创建的数据库名

3. **开启外网访问**（如果需要从本地连接）
   - 在 RDS 实例详情页
   - 点击"数据安全性"
   - 添加本地 IP 到白名单
   - 开启外网地址

## 初始化 PostGIS 扩展

连接到数据库并运行：
```sql
CREATE EXTENSION IF NOT EXISTS postgis;
```

可以使用 psql 命令行：
```bash
psql -h your-db-host.rds.aliyuncs.com -p 5432 -U your_username -d your_database_name -c "CREATE EXTENSION IF NOT EXISTS postgis;"
```

## 运行数据库迁移

```bash
cd /Users/Zhuanz/Documents/findyusports/Server/api
npm run migration:run
```

## 启动后端服务

```bash
npm start
```

## 注意事项

- 确保阿里云数据库已开启 PostGIS 扩展
- 如果从本地连接，需要开启外网访问并添加 IP 白名单
- 数据库密码要妥善保管，不要提交到 Git
- `.env` 文件已在 `.gitignore` 中，不会被提交
