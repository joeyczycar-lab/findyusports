#!/bin/bash

# Mac 快速部署脚本
# 使用方法：chmod +x scripts/mac-quick-start.sh && ./scripts/mac-quick-start.sh

set -e  # 遇到错误立即退出

echo "=========================================="
echo "🚀 Findyu Sports - Mac 快速部署"
echo "=========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查是否在项目根目录
if [ ! -d "Web/webapp" ]; then
    echo -e "${RED}❌ 错误：请在项目根目录运行此脚本${NC}"
    echo "   当前目录：$(pwd)"
    exit 1
fi

# 1. 检查 Homebrew
echo -e "${YELLOW}[1/6] 检查 Homebrew...${NC}"
if ! command -v brew &> /dev/null; then
    echo "⚠️  Homebrew 未安装，正在安装..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo -e "${GREEN}✅ Homebrew 安装完成${NC}"
else
    echo -e "${GREEN}✅ Homebrew 已安装: $(brew --version | head -n 1)${NC}"
fi

# 2. 检查 Node.js
echo ""
echo -e "${YELLOW}[2/6] 检查 Node.js...${NC}"
if ! command -v node &> /dev/null; then
    echo "⚠️  Node.js 未安装"
    echo "   推荐使用 nvm 安装："
    echo "   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
    echo "   nvm install 20"
    echo "   nvm use 20"
    exit 1
else
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✅ Node.js 已安装: $NODE_VERSION${NC}"
    
    # 检查版本是否 >= 20
    MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$MAJOR_VERSION" -lt 20 ]; then
        echo -e "${YELLOW}⚠️  建议使用 Node.js 20 或更高版本${NC}"
    fi
fi

# 3. 检查 Git
echo ""
echo -e "${YELLOW}[3/6] 检查 Git...${NC}"
if ! command -v git &> /dev/null; then
    echo "⚠️  Git 未安装，正在安装..."
    brew install git
    echo -e "${GREEN}✅ Git 安装完成${NC}"
else
    echo -e "${GREEN}✅ Git 已安装: $(git --version)${NC}"
fi

# 检查 Git 配置
if [ -z "$(git config --global user.name)" ]; then
    echo -e "${YELLOW}⚠️  Git 用户信息未配置${NC}"
    echo "   请运行："
    echo "   git config --global user.name \"你的名字\""
    echo "   git config --global user.email \"你的邮箱\""
fi

# 4. 安装前端依赖
echo ""
echo -e "${YELLOW}[4/6] 安装前端依赖...${NC}"
cd Web/webapp

if [ ! -d "node_modules" ]; then
    echo "正在安装依赖（这可能需要几分钟）..."
    npm install
    echo -e "${GREEN}✅ 依赖安装完成${NC}"
else
    echo -e "${GREEN}✅ 依赖已存在${NC}"
    echo "   如果需要重新安装，请运行：rm -rf node_modules && npm install"
fi

# 5. 检查环境变量文件
echo ""
echo -e "${YELLOW}[5/6] 检查环境变量文件...${NC}"
if [ ! -f ".env.local" ]; then
    echo -e "${YELLOW}⚠️  .env.local 文件不存在${NC}"
    echo "   正在创建模板文件..."
    cat > .env.local << 'EOF'
# 高德地图 API Key
NEXT_PUBLIC_AMAP_KEY=你的高德地图Key

# 后端 API 地址
NEXT_PUBLIC_API_BASE=http://localhost:4000
EOF
    echo -e "${GREEN}✅ 已创建 .env.local 模板文件${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  请编辑 .env.local 文件，填入你的配置：${NC}"
    echo "   - NEXT_PUBLIC_AMAP_KEY: 你的高德地图 API Key"
    echo "   - NEXT_PUBLIC_API_BASE: 后端 API 地址"
    echo ""
    echo "   可以使用以下命令编辑："
    echo "   nano .env.local"
    echo "   或"
    echo "   open -a TextEdit .env.local"
else
    echo -e "${GREEN}✅ .env.local 文件已存在${NC}"
    
    # 检查是否包含必要的变量
    if ! grep -q "NEXT_PUBLIC_AMAP_KEY" .env.local; then
        echo -e "${YELLOW}⚠️  .env.local 中缺少 NEXT_PUBLIC_AMAP_KEY${NC}"
    fi
    if ! grep -q "NEXT_PUBLIC_API_BASE" .env.local; then
        echo -e "${YELLOW}⚠️  .env.local 中缺少 NEXT_PUBLIC_API_BASE${NC}"
    fi
fi

# 6. 验证安装
echo ""
echo -e "${YELLOW}[6/6] 验证安装...${NC}"
cd ../..

echo ""
echo "=========================================="
echo -e "${GREEN}✅ 设置完成！${NC}"
echo "=========================================="
echo ""
echo "下一步操作："
echo ""
echo "1. 配置环境变量（如果还没有）："
echo "   cd Web/webapp"
echo "   nano .env.local  # 或使用其他编辑器"
echo ""
echo "2. 启动开发服务器："
echo "   cd Web/webapp"
echo "   npm run dev"
echo ""
echo "3. 访问网站："
echo "   http://localhost:3000"
echo ""
echo "=========================================="
echo ""



















