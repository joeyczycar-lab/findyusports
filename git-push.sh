#!/bin/bash

# 便捷的 Git 提交和推送脚本
# 使用方法: ./git-push.sh "提交信息"

set -e

# 检查是否有未提交的更改
if [ -z "$(git status --porcelain)" ]; then
  echo "✅ 没有需要提交的更改"
  exit 0
fi

# 获取提交信息
COMMIT_MSG="${1:-Update: $(date +'%Y-%m-%d %H:%M:%S')}"

echo "📝 提交信息: $COMMIT_MSG"
echo ""

# 添加所有更改
echo "📦 添加所有更改..."
git add -A

# 提交
echo "💾 提交更改..."
git commit -m "$COMMIT_MSG"

# 推送
echo "🚀 推送到远程仓库..."
git push

echo ""
echo "✅ 完成！所有更改已推送到远程仓库"

