#!/bin/bash
# 快速重启 Next.js 开发服务器

cd "$(dirname "$0")"

echo "🛑 停止现有服务..."
lsof -ti :3000 | xargs kill -9 2>/dev/null || true
sleep 1

echo "🧹 清理缓存..."
rm -rf .next
rm -rf node_modules/.cache
rm -rf .swc

echo "🚀 启动开发服务器..."
npm run dev
