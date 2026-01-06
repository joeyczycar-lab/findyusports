#!/bin/bash

# Mac 环境快速设置脚本
# 使用方法：chmod +x scripts/mac-setup.sh && ./scripts/mac-setup.sh

echo "=========================================="
echo "Mac 环境快速设置脚本"
echo "=========================================="
echo ""

# 检查是否在项目根目录
if [ ! -f "package.json" ] && [ ! -d "Web/webapp" ]; then
    echo "❌ 错误：请在项目根目录运行此脚本"
    exit 1
fi

# 1. 检查 Homebrew
echo "[1] 检查 Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "⚠️  Homebrew 未安装，正在安装..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew 已安装"
fi

# 2. 检查 Node.js
echo ""
echo "[2] 检查 Node.js..."
if ! command -v node &> /dev/null; then
    echo "⚠️  Node.js 未安装，正在安装..."
    brew install node
else
    echo "✅ Node.js 已安装: $(node --version)"
fi

# 3. 检查 Git
echo ""
echo "[3] 检查 Git..."
if ! command -v git &> /dev/null; then
    echo "⚠️  Git 未安装，正在安装..."
    brew install git
else
    echo "✅ Git 已安装: $(git --version)"
fi

# 4. 安装前端依赖
echo ""
echo "[4] 安装前端依赖..."
if [ -d "Web/webapp" ]; then
    cd Web/webapp
    if [ ! -d "node_modules" ]; then
        echo "正在安装依赖..."
        npm install
    else
        echo "✅ 依赖已安装"
    fi
    cd ../..
else
    echo "⚠️  未找到 Web/webapp 目录"
fi

# 5. 检查环境变量文件
echo ""
echo "[5] 检查环境变量文件..."
if [ ! -f "Web/webapp/.env.local" ]; then
    echo "⚠️  .env.local 文件不存在"
    echo "请创建 Web/webapp/.env.local 文件并填入配置："
    echo ""
    echo "NEXT_PUBLIC_AMAP_KEY=你的高德地图Key"
    echo "NEXT_PUBLIC_API_BASE=http://localhost:4000"
    echo ""
else
    echo "✅ .env.local 文件存在"
fi

# 6. 配置 Git（如果需要）
echo ""
echo "[6] 配置 Git..."
if [ -z "$(git config --global user.name)" ]; then
    echo "⚠️  Git 用户信息未配置"
    echo "请运行："
    echo "  git config --global user.name \"你的名字\""
    echo "  git config --global user.email \"你的邮箱\""
else
    echo "✅ Git 已配置"
fi

echo ""
echo "=========================================="
echo "设置完成！"
echo "=========================================="
echo ""
echo "下一步："
echo "1. 配置 .env.local 文件（如果还没有）"
echo "2. 运行: cd Web/webapp && npm run dev"
echo "3. 访问: http://localhost:3000"
echo ""




















