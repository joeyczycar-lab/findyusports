#!/usr/bin/env bash
# Railway 数据库导出 / 导入到阿里云 RDS
# 用法: ./migrate-railway-to-aliyun.sh export | import

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

export_railway() {
  echo "=========================================="
  echo "  从 Railway 导出 PostgreSQL 数据"
  echo "=========================================="
  echo ""
  echo "请从 Railway 控制台复制 DATABASE_URL："
  echo "  项目 → Postgres 服务 → Variables → DATABASE_URL"
  echo ""
  read -p "粘贴 Railway DATABASE_URL: " RAILWAY_URL
  if [ -z "$RAILWAY_URL" ]; then
    echo "❌ DATABASE_URL 不能为空"
    exit 1
  fi

  DUMP_FILE="railway_dump_$(date +%Y%m%d_%H%M%S).sql"
  echo ""
  echo "正在导出（可能需要 SSL）..."
  export PGSSLMODE=require 2>/dev/null || true
  if pg_dump "$RAILWAY_URL" --no-owner --no-acl -f "$DUMP_FILE" 2>/dev/null; then
    echo "✅ 导出成功: $DUMP_FILE"
    echo "   文件大小: $(du -h "$DUMP_FILE" | cut -f1)"
  else
    # 部分环境不需要 SSL
    unset PGSSLMODE 2>/dev/null || true
    if pg_dump "$RAILWAY_URL" --no-owner --no-acl -f "$DUMP_FILE"; then
      echo "✅ 导出成功: $DUMP_FILE"
      echo "   文件大小: $(du -h "$DUMP_FILE" | cut -f1)"
    else
      echo "❌ 导出失败，请检查 DATABASE_URL 和本机 pg_dump"
      exit 1
    fi
  fi
  echo ""
  echo "下一步: 在阿里云 RDS 创建好数据库并开启 PostGIS 后，执行"
  echo "  ./migrate-railway-to-aliyun.sh import"
}

import_aliyun() {
  echo "=========================================="
  echo "  导入到阿里云 RDS PostgreSQL"
  echo "=========================================="
  echo ""
  read -p "阿里云 RDS 主机 (例: pgm-xxx.pg.rds.aliyuncs.com): " ALI_HOST
  read -p "端口 (默认 5432): " ALI_PORT
  read -p "数据库用户名: " ALI_USER
  read -s -p "数据库密码: " ALI_PASS
  echo ""
  read -p "数据库名 (默认 venues): " ALI_DB
  echo ""
  echo "当前目录下的 .sql 文件:"
  ls -la *.sql 2>/dev/null || true
  echo ""
  read -p "要导入的 dump 文件路径 (例: railway_dump_20250124_120000.sql): " DUMP_PATH

  ALI_PORT="${ALI_PORT:-5432}"
  ALI_DB="${ALI_DB:-venues}"

  if [ -z "$ALI_HOST" ] || [ -z "$ALI_USER" ] || [ -z "$ALI_PASS" ]; then
    echo "❌ 主机、用户名、密码不能为空"
    exit 1
  fi
  if [ ! -f "$DUMP_PATH" ]; then
    echo "❌ 文件不存在: $DUMP_PATH"
    exit 1
  fi

  # 含特殊字符的密码在 URL 里要编码，这里用 PGPASSWORD 更简单
  export PGPASSWORD="$ALI_PASS"
  ALI_URL="postgresql://${ALI_USER}@${ALI_HOST}:${ALI_PORT}/${ALI_DB}?sslmode=require"
  echo ""
  echo "正在导入到 ${ALI_HOST}:${ALI_PORT}/${ALI_DB} ..."
  if psql "$ALI_URL" -f "$DUMP_PATH" 2>/dev/null; then
    echo "✅ 导入成功"
  else
    # 部分 RDS 未开 SSL
    ALI_URL_PLAIN="postgresql://${ALI_USER}@${ALI_HOST}:${ALI_PORT}/${ALI_DB}"
    if psql "$ALI_URL_PLAIN" -f "$DUMP_PATH"; then
      echo "✅ 导入成功"
    else
      echo "❌ 导入失败，请检查白名单、账号权限、PostGIS 是否已创建"
      unset PGPASSWORD
      exit 1
    fi
  fi
  unset PGPASSWORD
  echo ""
  echo "下一步: 在后端环境（Railway Variables 或 .env）中把 DATABASE_URL 改为阿里云连接串："
  echo "  postgresql://${ALI_USER}:密码@${ALI_HOST}:${ALI_PORT}/${ALI_DB}"
  echo "  若 RDS 要求 SSL，可加 ?sslmode=require 并设置 DB_SSL=true"
}

case "${1:-}" in
  export) export_railway ;;
  import) import_aliyun ;;
  *)
    echo "用法: $0 export | import"
    echo "  export  从 Railway 导出到本地 .sql 文件"
    echo "  import  从本地 .sql 文件导入到阿里云 RDS"
    exit 1
    ;;
esac
