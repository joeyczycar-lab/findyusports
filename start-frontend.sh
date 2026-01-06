#!/bin/bash

# 启动前端服务的脚本

echo "🚀 正在启动前端服务..."
echo "📁 工作目录: $(pwd)"

cd Web/webapp

# 检查 node_modules 是否存在
if [ ! -d "node_modules" ]; then
  echo "📦 检测到 node_modules 不存在，正在安装依赖..."
  npm install
fi

echo "🔧 启动开发服务器..."
echo "📍 前端服务将在 http://localhost:3000 上运行"
echo ""

npm run dev


