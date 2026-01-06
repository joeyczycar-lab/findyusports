#!/bin/bash

# 网站开发环境启动脚本
# 使用方法: ./start-dev.sh

set -e

echo "🚀 启动开发环境..."
echo ""

# 检查 Node.js
if ! command -v node &> /dev/null; then
  echo "❌ 错误: 未安装 Node.js"
  echo "请先安装 Node.js: https://nodejs.org/"
  exit 1
fi

echo "✅ Node.js 版本: $(node --version)"
echo "✅ npm 版本: $(npm --version)"
echo ""

# 检查端口占用
if lsof -ti:3000 &> /dev/null; then
  echo "⚠️  警告: 端口 3000 已被占用"
  echo "请先关闭占用端口的程序，或使用其他端口"
  exit 1
fi

if lsof -ti:4000 &> /dev/null; then
  echo "⚠️  警告: 端口 4000 已被占用"
  echo "请先关闭占用端口的程序，或使用其他端口"
  exit 1
fi

# 检查前端依赖
if [ ! -d "Web/webapp/node_modules" ]; then
  echo "📦 安装前端依赖..."
  cd Web/webapp
  npm install
  cd ../..
fi

# 检查后端依赖
if [ ! -d "Server/api/node_modules" ]; then
  echo "📦 安装后端依赖..."
  cd Server/api
  npm install
  cd ../..
fi

# 检查环境变量
if [ ! -f "Web/webapp/.env.local" ]; then
  echo "⚠️  警告: 未找到 .env.local 文件"
  echo "请创建 Web/webapp/.env.local 并配置环境变量"
  echo ""
  echo "示例内容："
  echo "NEXT_PUBLIC_API_BASE=http://localhost:4000"
  echo "NEXT_PUBLIC_AMAP_KEY=你的高德地图Key"
  exit 1
fi

echo "✅ 环境检查完成"
echo ""
echo "📋 启动选项："
echo "  1. 只启动前端 (http://localhost:3000)"
echo "  2. 只启动后端 (http://localhost:4000)"
echo "  3. 同时启动前端和后端"
echo ""
read -p "请选择 (1/2/3): " choice

case $choice in
  1)
    echo ""
    echo "🌐 启动前端开发服务器..."
    cd Web/webapp
    npm run dev
    ;;
  2)
    echo ""
    echo "🔧 启动后端 API 服务器..."
    cd Server/api
    npm run dev
    ;;
  3)
    echo ""
    echo "🚀 同时启动前端和后端..."
    echo ""
    echo "前端将在 http://localhost:3000 运行"
    echo "后端将在 http://localhost:4000 运行"
    echo ""
    echo "按 Ctrl+C 停止所有服务"
    echo ""
    
    # 启动后端（后台运行）
    cd Server/api
    npm run dev > /tmp/api.log 2>&1 &
    API_PID=$!
    echo "✅ 后端已启动 (PID: $API_PID)"
    
    # 等待后端启动
    sleep 3
    
    # 启动前端（前台运行）
    cd ../../Web/webapp
    npm run dev
    
    # 清理：如果前端退出，也停止后端
    kill $API_PID 2>/dev/null || true
    ;;
  *)
    echo "❌ 无效选择"
    exit 1
    ;;
esac


