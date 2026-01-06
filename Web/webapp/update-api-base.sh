#!/bin/bash

# 更新 API 基础地址配置脚本

ENV_FILE=".env.local"

echo "🔧 更新 API 基础地址配置"
echo ""

# 检查文件是否存在
if [ ! -f "$ENV_FILE" ]; then
  echo "⚠️  .env.local 文件不存在，正在创建..."
  cat > "$ENV_FILE" << EOF
# 后端 API 地址
NEXT_PUBLIC_API_BASE=http://localhost:4000

# 高德地图 API Key（如果需要地图功能，请填写）
# NEXT_PUBLIC_AMAP_KEY=your_amap_key_here

# 可选：滚动联动阈值（毫秒）
NEXT_PUBLIC_SCROLL_THROTTLE_MS=300
NEXT_PUBLIC_SCROLL_SUPPRESS_MS=800
EOF
  echo "✅ 已创建 .env.local 文件"
else
  echo "📝 更新现有 .env.local 文件..."
  
  # 备份原文件
  cp "$ENV_FILE" "$ENV_FILE.backup"
  echo "✅ 已备份原文件为 .env.local.backup"
  
  # 更新 API 地址为本地
  sed -i.bak 's|NEXT_PUBLIC_API_BASE=.*|NEXT_PUBLIC_API_BASE=http://localhost:4000|' "$ENV_FILE"
  
  # 清理备份文件
  rm -f "$ENV_FILE.bak"
  
  echo "✅ 已更新 NEXT_PUBLIC_API_BASE 为 http://localhost:4000"
fi

echo ""
echo "📋 当前配置："
grep "NEXT_PUBLIC_API_BASE" "$ENV_FILE" || echo "  (未找到配置)"
echo ""
echo "✅ 配置更新完成！"
echo ""
echo "⚠️  重要提示："
echo "   1. 确保本地后端服务正在运行（端口 4000）"
echo "   2. 重启前端开发服务器才能生效"
echo "   3. 硬刷新浏览器页面（Cmd+Shift+R）"


