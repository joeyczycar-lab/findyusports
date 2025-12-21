#!/bin/bash

echo "=========================================="
echo "  添加 PostGIS 扩展到 Railway 数据库"
echo "=========================================="
echo ""

DATABASE_URL="postgresql://postgres:wzQlXXtAwygbvCXsNkDuWxqTnYoimUtE@yamanote.proxy.rlwy.net:29122/railway"

echo "方法 1：使用 Railway Web 界面（推荐）"
echo "----------------------------------------"
echo "1. 访问 Railway: https://railway.app"
echo "2. 进入项目 → 点击 'Postgres' 服务"
echo "3. 点击 '数据库' 标签"
echo "4. 点击 '扩展'（Extensions）子标签"
echo "5. 点击 '添加扩展' → 搜索 'postgis' → 添加"
echo ""

if command -v railway > /dev/null 2>&1; then
  echo "方法 2：使用 Railway CLI"
  echo "----------------------------------------"
  read -p "是否使用 Railway CLI 添加？(y/n): " use_cli
  if [ "$use_cli" = "y" ] || [ "$use_cli" = "Y" ]; then
    echo "正在添加 PostGIS 扩展..."
    railway run psql -c "CREATE EXTENSION IF NOT EXISTS postgis;" && echo "✅ PostGIS 扩展已添加"
  fi
fi

if command -v psql > /dev/null 2>&1; then
  echo ""
  echo "方法 3：使用本地 psql"
  echo "----------------------------------------"
  read -p "是否使用本地 psql 添加？(y/n): " use_psql
  if [ "$use_psql" = "y" ] || [ "$use_psql" = "Y" ]; then
    echo "正在添加 PostGIS 扩展..."
    psql "$DATABASE_URL" -c "CREATE EXTENSION IF NOT EXISTS postgis;" && echo "✅ PostGIS 扩展已添加"
  fi
fi

echo ""
echo "添加完成后，运行迁移："
echo "  cd /Users/Zhuanz/Documents/findyusports/Server/api"
echo "  npm run migration:run"
