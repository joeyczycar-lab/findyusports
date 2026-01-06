#!/bin/bash
# Mac 数据库恢复脚本
# 用途：从 Windows 备份的 SQL 文件恢复数据库到 Mac

echo "=== 数据库恢复工具 ==="
echo ""

# 检查 Docker 是否运行
if ! docker ps > /dev/null 2>&1; then
    echo "❌ Docker 未运行，请先启动 Docker Desktop"
    exit 1
fi

# 检查备份文件
BACKUP_FILE=""
if [ -f "backup_venues.sql" ]; then
    BACKUP_FILE="backup_venues.sql"
elif [ -f "../backup_venues.sql" ]; then
    BACKUP_FILE="../backup_venues.sql"
else
    # 查找最新的备份文件
    BACKUP_FILE=$(find . -name "backup_venues_*.sql" -type f -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)
    if [ -z "$BACKUP_FILE" ]; then
        BACKUP_FILE=$(find .. -name "backup_venues_*.sql" -type f -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)
    fi
fi

if [ -z "$BACKUP_FILE" ] || [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ 未找到备份文件！"
    echo "   请将备份文件放在当前目录或上一级目录"
    echo "   备份文件名格式: backup_venues_*.sql"
    exit 1
fi

echo "📦 找到备份文件: $BACKUP_FILE"
FILE_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
echo "   文件大小: $FILE_SIZE"
echo ""

# 检查数据库容器
cd api 2>/dev/null || cd Server/api 2>/dev/null || {
    echo "❌ 未找到 api 目录，请确保在项目根目录运行此脚本"
    exit 1
}

# 检查并启动数据库容器
if ! docker ps -a --filter "name=venues_pg" --format "{{.Names}}" | grep -q venues_pg; then
    echo "⚠️  数据库容器不存在，正在创建..."
    docker compose up -d
    echo "   等待数据库启动..."
    sleep 5
fi

if ! docker ps --filter "name=venues_pg" --format "{{.Names}}" | grep -q venues_pg; then
    echo "⚠️  数据库容器未运行，正在启动..."
    docker compose start db
    echo "   等待数据库启动..."
    sleep 5
fi

# 检查 PostGIS 扩展
echo "🔧 检查 PostGIS 扩展..."
docker exec venues_pg psql -U postgres -d venues -c "CREATE EXTENSION IF NOT EXISTS postgis;" > /dev/null 2>&1

# 恢复数据库
echo "📥 正在恢复数据库..."
echo "   这可能需要几分钟，请耐心等待..."

# 获取备份文件的绝对路径
if [[ "$BACKUP_FILE" != /* ]]; then
    BACKUP_FILE="$(cd "$(dirname "$BACKUP_FILE")" && pwd)/$(basename "$BACKUP_FILE")"
fi

docker exec -i venues_pg psql -U postgres venues < "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 数据库恢复成功！"
    echo ""
    echo "📋 验证数据："
    echo "   docker exec -it venues_pg psql -U postgres -d venues -c '\\dt'"
    echo ""
    echo "🚀 启动后端服务："
    echo "   npm run dev"
else
    echo ""
    echo "❌ 数据库恢复失败！"
    echo "   请检查备份文件是否完整"
fi












