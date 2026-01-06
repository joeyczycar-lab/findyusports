#!/bin/bash

# 启动开发环境脚本 - 同时启动前端和后端

set -e

echo "🚀 启动开发环境..."
echo ""

# 检查端口是否被占用
check_port() {
  PORT=$1
  if lsof -ti:$PORT > /dev/null 2>&1; then
    echo "⚠️  端口 $PORT 已被占用"
    read -p "是否要停止占用该端口的进程？(y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      lsof -ti:$PORT | xargs kill -9 2>/dev/null
      sleep 2
      echo "✅ 已停止占用端口 $PORT 的进程"
    else
      echo "❌ 请手动停止占用端口 $PORT 的进程"
      exit 1
    fi
  fi
}

# 检查前端端口
echo "检查端口 3000..."
check_port 3000

# 检查后端端口
echo "检查端口 4000..."
check_port 4000

echo ""
echo "📦 启动后端服务 (http://localhost:4000)..."
cd Server/api
npm run dev > /tmp/backend.log 2>&1 &
BACKEND_PID=$!
cd ../..

echo "📦 启动前端服务 (http://localhost:3000)..."
cd Web/webapp
npm run dev > /tmp/frontend.log 2>&1 &
FRONTEND_PID=$!
cd ../..

echo ""
echo "✅ 服务已启动"
echo "   - 后端 PID: $BACKEND_PID"
echo "   - 前端 PID: $FRONTEND_PID"
echo ""
echo "等待服务启动..."
sleep 10

# 检查后端服务
echo "检查后端服务..."
for i in {1..10}; do
  if curl -s http://localhost:4000/health > /dev/null 2>&1; then
    echo "✅ 后端服务已就绪"
    break
  fi
  if [ $i -eq 10 ]; then
    echo "❌ 后端服务启动失败，请查看日志: tail -f /tmp/backend.log"
  else
    sleep 2
  fi
done

# 检查前端服务
echo "检查前端服务..."
for i in {1..10}; do
  if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ 前端服务已就绪"
    break
  fi
  if [ $i -eq 10 ]; then
    echo "❌ 前端服务启动失败，请查看日志: tail -f /tmp/frontend.log"
  else
    sleep 2
  fi
done

echo ""
echo "🌐 访问地址："
echo "   - 前端: http://localhost:3000"
echo "   - 后端: http://localhost:4000"
echo ""
echo "📋 查看日志："
echo "   - 后端: tail -f /tmp/backend.log"
echo "   - 前端: tail -f /tmp/frontend.log"
echo ""
echo "按 Ctrl+C 停止所有服务"

# 捕获 Ctrl+C 信号
trap "echo ''; echo '停止服务...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" INT

# 等待进程
wait $BACKEND_PID
wait $FRONTEND_PID


