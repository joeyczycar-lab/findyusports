#!/bin/bash
echo "🔄 重启 Next.js 开发服务器..."
cd "$(dirname "$0")"

# 停止现有服务
if lsof -i :3000 >/dev/null 2>&1; then
  echo "停止现有服务..."
  lsof -ti :3000 | xargs kill -9 2>/dev/null || true
  sleep 2
fi

# 清理缓存
echo "清理缓存..."
rm -rf .next
rm -rf node_modules/.cache

# 启动服务
echo "启动开发服务器..."
npm run dev
