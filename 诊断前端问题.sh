#!/bin/bash

echo "🔍 诊断前端问题..."
echo ""

echo "1️⃣ 检查端口占用:"
if lsof -ti:3000 > /dev/null 2>&1; then
  echo "  ✅ 端口 3000 已被占用 (PID: $(lsof -ti:3000))"
else
  echo "  ❌ 端口 3000 未被占用"
fi

echo ""
echo "2️⃣ 检查服务响应:"
if curl -s http://localhost:3000 > /dev/null 2>&1; then
  echo "  ✅ 服务可以访问"
  echo "  📋 响应头:"
  curl -s -I http://localhost:3000 | head -5
else
  echo "  ❌ 服务无法访问"
fi

echo ""
echo "3️⃣ 检查进程:"
ps aux | grep "next dev" | grep -v grep | head -3

echo ""
echo "4️⃣ 检查编译错误:"
if [ -f "Web/webapp/.next/trace" ]; then
  echo "  📋 最近的错误:"
  tail -20 Web/webapp/.next/trace | grep -i error | head -5 || echo "  没有找到错误"
else
  echo "  ⚠️  没有找到 trace 文件"
fi

echo ""
echo "5️⃣ 建议操作:"
echo "  - 如果端口被占用但无法访问，尝试:"
echo "    cd Web/webapp && rm -rf .next && npm run dev"
echo "  - 如果编译错误，检查:"
echo "    cd Web/webapp && npm run build"
echo "  - 清除缓存:"
echo "    cd Web/webapp && rm -rf .next node_modules/.cache"
