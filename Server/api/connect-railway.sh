#!/bin/bash

echo "=========================================="
echo "  Railway 数据库连接配置"
echo "=========================================="
echo ""
echo "请从 Railway 控制台获取以下信息："
echo "1. 访问 https://railway.app"
echo "2. 进入你的项目"
echo "3. 点击 PostgreSQL 数据库服务"
echo "4. 点击 'Variables' 标签"
echo "5. 找到 DATABASE_URL 或 POSTGRES_URL"
echo ""
echo "DATABASE_URL 格式示例："
echo "postgresql://postgres:password@containers-us-west-xxx.railway.app:5432/railway"
echo ""
read -p "请输入 DATABASE_URL: " DATABASE_URL

if [ -z "$DATABASE_URL" ]; then
  echo "❌ DATABASE_URL 不能为空"
  exit 1
fi

echo ""
read -p "JWT_SECRET (留空将自动生成): " JWT_SECRET

if [ -z "$JWT_SECRET" ]; then
  JWT_SECRET=$(openssl rand -hex 32 2>/dev/null || echo "change_this_secret_key_$(date +%s)")
  echo "✅ 已自动生成 JWT_SECRET"
fi

cat > .env << ENVFILE
# Railway 数据库连接
DATABASE_URL=$DATABASE_URL

# Railway 数据库需要 SSL
DB_SSL=true

# 其他配置
PORT=4000

# JWT配置
JWT_SECRET=$JWT_SECRET

# 阿里云OSS配置（可选，如果需要图片上传功能）
# OSS_REGION=oss-cn-hangzhou
# OSS_ACCESS_KEY_ID=your_access_key_id
# OSS_ACCESS_KEY_SECRET=your_access_key_secret
# OSS_BUCKET=venues-images
# OSS_HOTLINK_SECRET=your_hotlink_secret_key
ENVFILE

echo ""
echo "✅ .env 文件已创建！"
echo ""
echo "配置内容："
echo "- DATABASE_URL: ${DATABASE_URL:0:50}..."
echo "- DB_SSL: true"
echo "- JWT_SECRET: ${JWT_SECRET:0:20}..."
echo ""
echo "下一步操作："
echo "1. 初始化 PostGIS: railway run psql -c 'CREATE EXTENSION IF NOT EXISTS postgis;'"
echo "2. 运行迁移: npm run migration:run"
echo "3. 启动服务: npm start"
