#!/bin/bash
# 设置本地数据库的快速脚本

echo "🔧 设置本地数据库..."
echo ""

# 检查 PostgreSQL 是否安装
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL 未安装"
    echo ""
    echo "请先安装 PostgreSQL:"
    echo "  brew install postgresql@14"
    echo "  brew services start postgresql@14"
    exit 1
fi

# 检查 PostgreSQL 是否运行
if ! pg_isready -U postgres &> /dev/null; then
    echo "⚠️  PostgreSQL 服务未运行"
    echo ""
    echo "请启动 PostgreSQL:"
    echo "  brew services start postgresql@14"
    exit 1
fi

echo "✅ PostgreSQL 已安装并运行"
echo ""

# 创建数据库（如果不存在）
if psql -U postgres -lqt | cut -d \| -f 1 | grep -qw venues; then
    echo "✅ 数据库 'venues' 已存在"
else
    echo "📦 创建数据库 'venues'..."
    createdb -U postgres venues
    if [ $? -eq 0 ]; then
        echo "✅ 数据库创建成功"
    else
        echo "❌ 数据库创建失败"
        exit 1
    fi
fi

echo ""
echo "📝 备份当前 .env 文件..."
if [ -f .env ]; then
    cp .env .env.backup.$(date +%Y%m%d_%H%M%S)
    echo "✅ 已备份到 .env.backup.*"
fi

echo ""
echo "✏️  更新 .env 文件使用本地数据库..."
cat > .env.local <<EOF
# 本地数据库配置
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=postgres
DB_NAME=venues

# 其他配置
PORT=4000
JWT_SECRET=8f2c28d25327d90f3751d54f10fd6d03d8d71192682e19389907b168b8123bfe

# OSS 配置（如果需要上传图片）
# OSS_ACCESS_KEY_ID=your_key
# OSS_ACCESS_KEY_SECRET=your_secret
# OSS_REGION=cn-hangzhou
# OSS_BUCKET=venues-images
EOF

echo ""
echo "⚠️  注意：已创建 .env.local 文件"
echo "请手动将 .env.local 的内容复制到 .env，或者："
echo "  cp .env.local .env"
echo ""
echo "然后运行数据库迁移："
echo "  npm run migrate:page-view"
echo "  npm run migrate:add-contact"
echo "  npm run migrate:add-is-public"
echo "  npm run migrate:add-district-code"
echo ""
echo "最后启动服务："
echo "  npm run dev"


