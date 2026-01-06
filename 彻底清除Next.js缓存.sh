#!/bin/bash

# 彻底清除 Next.js 缓存脚本

cd "$(dirname "$0")/Web/webapp" || exit 1

echo "🧹 正在清除 Next.js 所有缓存..."

# 停止所有 Next.js 进程
echo "1. 停止 Next.js 进程..."
pkill -f "next dev" 2>/dev/null
sleep 2

# 清除所有缓存目录
echo "2. 清除缓存目录..."
rm -rf .next
rm -rf node_modules/.cache
rm -rf .swc

echo "✅ 缓存已清除"
echo ""
echo "3. 重新启动开发服务器..."
npm run dev


