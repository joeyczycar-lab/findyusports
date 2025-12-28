#!/bin/bash

echo "🔍 检查服务状态..."
echo ""

echo "📦 前端服务 (端口 3000):"
if lsof -ti:3000 > /dev/null 2>&1; then
  echo "  ✅ 正在运行 (PID: $(lsof -ti:3000))"
  if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "  ✅ 可以访问"
  else
    echo "  ❌ 无法访问"
  fi
else
  echo "  ❌ 未运行"
fi

echo ""
echo "📦 后端服务 (端口 4000):"
if lsof -ti:4000 > /dev/null 2>&1; then
  echo "  ✅ 正在运行 (PID: $(lsof -ti:4000))"
  if curl -s http://localhost:4000/health > /dev/null 2>&1; then
    echo "  ✅ 可以访问"
    echo "  📋 健康检查: $(curl -s http://localhost:4000/health)"
  else
    echo "  ❌ 无法访问"
  fi
else
  echo "  ❌ 未运行"
fi

echo ""
echo "🌐 访问地址:"
echo "  - 前端: http://localhost:3000"
echo "  - 后端: http://localhost:4000"
echo "  - 添加场地: http://localhost:3000/admin/add-venue"

