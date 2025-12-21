#!/bin/bash

echo "=========================================="
echo "  阿里云数据库连接配置"
echo "=========================================="
echo ""
echo "请提供以下阿里云数据库信息："
echo ""

read -p "数据库主机地址 (DB_HOST): " DB_HOST
read -p "数据库端口 (DB_PORT，默认5432): " DB_PORT
read -p "数据库用户名 (DB_USER): " DB_USER
read -s -p "数据库密码 (DB_PASS): " DB_PASS
echo ""
read -p "数据库名称 (DB_NAME): " DB_NAME
read -p "JWT_SECRET (留空将自动生成): " JWT_SECRET

if [ -z "$DB_PORT" ]; then
  DB_PORT=5432
fi

if [ -z "$JWT_SECRET" ]; then
  JWT_SECRET=$(openssl rand -hex 32 2>/dev/null || echo "change_this_secret_key_$(date +%s)")
  echo "✅ 已自动生成 JWT_SECRET"
fi

# 创建 .env 文件
cat > .env << ENVFILE
# 阿里云数据库配置
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_USER=$DB_USER
DB_PASS=$DB_PASS
DB_NAME=$DB_NAME

# 阿里云数据库通常需要 SSL（根据实际情况设置）
# DB_SSL=true

# 其他配置
PORT=4000

# JWT配置
JWT_SECRET=$JWT_SECRET

# 阿里云OSS配置（如果需要图片上传功能）
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
echo "- DB_HOST: $DB_HOST"
echo "- DB_PORT: $DB_PORT"
echo "- DB_USER: $DB_USER"
echo "- DB_NAME: $DB_NAME"
echo "- JWT_SECRET: ${JWT_SECRET:0:20}..."
echo ""
echo "下一步："
echo "1. 确保阿里云数据库已开启 PostGIS 扩展"
echo "2. 运行迁移: npm run migration:run"
echo "3. 启动服务: npm start"
