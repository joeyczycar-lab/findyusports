#!/bin/bash

# 启动后端服务的脚本

echo "🚀 正在启动后端服务..."
echo "📁 工作目录: $(pwd)"

cd Server/api

# 检查 node_modules 是否存在
if [ ! -d "node_modules" ]; then
  echo "📦 检测到 node_modules 不存在，正在安装依赖..."
  npm install
fi

# 检查 .env 文件是否存在
if [ ! -f ".env" ]; then
  echo "⚠️  警告: .env 文件不存在"
  echo "💡 提示: 如果数据库连接失败，请创建 .env 文件并配置数据库连接"
fi

echo "🔧 启动开发服务器..."
echo "📍 后端服务将在 http://localhost:4000 上运行"
echo ""

npm run dev


