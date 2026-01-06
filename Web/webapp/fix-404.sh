#!/bin/bash
# 修复 Next.js 404 错误的脚本

echo "🔧 开始修复 Next.js 404 错误..."
echo ""

# 切换到项目目录
cd "$(dirname "$0")"

# 1. 停止可能正在运行的服务
echo "1️⃣ 检查并停止现有服务..."
if lsof -i :3000 >/dev/null 2>&1; then
  echo "   发现端口 3000 被占用，正在停止..."
  lsof -ti :3000 | xargs kill -9 2>/dev/null || true
  sleep 2
fi

# 2. 清理缓存
echo "2️⃣ 清理 Next.js 缓存..."
rm -rf .next
rm -rf node_modules/.cache
rm -rf .swc
echo "   ✅ 缓存已清理"

# 3. 检查依赖
echo "3️⃣ 检查依赖..."
if [ ! -d "node_modules" ]; then
  echo "   安装依赖..."
  npm install
else
  echo "   ✅ 依赖已安装"
fi

# 4. 启动服务
echo "4️⃣ 启动开发服务器..."
echo ""
echo "   🚀 服务将在 http://localhost:3000 启动"
echo "   📝 按 Ctrl+C 停止服务"
echo ""

npm run dev


