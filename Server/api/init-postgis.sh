#!/bin/bash

echo "初始化 PostGIS 扩展..."

DATABASE_URL="postgresql://postgres:wzQlXXtAwygbvCXsNkDuWxqTnYoimUtE@yamanote.proxy.rlwy.net:29122/railway"

if command -v psql > /dev/null 2>&1; then
  echo "使用 psql 连接..."
  psql "$DATABASE_URL" -c "CREATE EXTENSION IF NOT EXISTS postgis;" && echo "✅ PostGIS 扩展已创建"
else
  echo "⚠️ psql 未安装"
  echo ""
  echo "请使用以下方法之一初始化 PostGIS："
  echo ""
  echo "方法 1：安装 PostgreSQL 客户端"
  echo "  brew install postgresql"
  echo ""
  echo "方法 2：使用 Railway CLI"
  echo "  railway run psql -c 'CREATE EXTENSION IF NOT EXISTS postgis;'"
  echo ""
  echo "方法 3：在 Railway Web 界面执行 SQL"
  echo "  1. 访问 Railway Postgres 服务"
  echo "  2. 点击 '数据库' 标签"
  echo "  3. 点击 '扩展' 子标签"
  echo "  4. 添加 'postgis' 扩展"
fi
