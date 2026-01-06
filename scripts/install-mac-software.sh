#!/bin/bash

# Mac 开发环境一键安装脚本
# 使用方法：chmod +x scripts/install-mac-software.sh && ./scripts/install-mac-software.sh

set -e  # 遇到错误立即退出

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=========================================="
echo "🚀 Mac 开发环境一键安装"
echo "=========================================="
echo ""

# 1. 安装 Homebrew
echo -e "${BLUE}[1/8] 检查 Homebrew...${NC}"
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}⚠️  Homebrew 未安装，正在安装...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 添加 Homebrew 到 PATH（针对 Apple Silicon Mac）
    if [ -f "/opt/homebrew/bin/brew" ]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    echo -e "${GREEN}✅ Homebrew 安装完成${NC}"
else
    echo -e "${GREEN}✅ Homebrew 已安装: $(brew --version | head -n 1)${NC}"
fi

# 2. 安装 Git
echo ""
echo -e "${BLUE}[2/8] 检查 Git...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}⚠️  Git 未安装，正在安装...${NC}"
    brew install git
    echo -e "${GREEN}✅ Git 安装完成${NC}"
else
    echo -e "${GREEN}✅ Git 已安装: $(git --version)${NC}"
fi

# 检查 Git 配置
if [ -z "$(git config --global user.name)" ]; then
    echo -e "${YELLOW}⚠️  Git 用户信息未配置${NC}"
    echo "   请运行以下命令配置："
    echo "   git config --global user.name \"你的名字\""
    echo "   git config --global user.email \"你的邮箱\""
fi

# 3. 安装 nvm
echo ""
echo -e "${BLUE}[3/8] 检查 nvm...${NC}"
if [ ! -d "$HOME/.nvm" ]; then
    echo -e "${YELLOW}⚠️  nvm 未安装，正在安装...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    
    # 加载 nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    echo -e "${GREEN}✅ nvm 安装完成${NC}"
    echo -e "${YELLOW}⚠️  请重启终端或运行以下命令：${NC}"
    echo "   source ~/.zshrc"
    echo "   然后运行：nvm install 20"
else
    echo -e "${GREEN}✅ nvm 已安装${NC}"
    
    # 加载 nvm 并检查 Node.js
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    if command -v node &> /dev/null; then
        echo -e "${GREEN}   Node.js 版本: $(node --version)${NC}"
    else
        echo -e "${YELLOW}⚠️  Node.js 未安装，请运行：nvm install 20${NC}"
    fi
fi

# 4. 安装 Cursor
echo ""
echo -e "${BLUE}[4/8] 检查 Cursor...${NC}"
if [ ! -d "/Applications/Cursor.app" ]; then
    echo -e "${YELLOW}⚠️  Cursor 未安装，正在安装...${NC}"
    brew install --cask cursor
    echo -e "${GREEN}✅ Cursor 安装完成${NC}"
else
    echo -e "${GREEN}✅ Cursor 已安装${NC}"
fi

# 5. 安装 iTerm2
echo ""
echo -e "${BLUE}[5/8] 检查 iTerm2...${NC}"
if [ ! -d "/Applications/iTerm.app" ]; then
    echo -e "${YELLOW}⚠️  iTerm2 未安装，正在安装...${NC}"
    brew install --cask iterm2
    echo -e "${GREEN}✅ iTerm2 安装完成${NC}"
else
    echo -e "${GREEN}✅ iTerm2 已安装${NC}"
fi

# 6. 安装 Chrome
echo ""
echo -e "${BLUE}[6/8] 检查 Chrome...${NC}"
if [ ! -d "/Applications/Google Chrome.app" ]; then
    echo -e "${YELLOW}⚠️  Chrome 未安装，正在安装...${NC}"
    brew install --cask google-chrome
    echo -e "${GREEN}✅ Chrome 安装完成${NC}"
else
    echo -e "${GREEN}✅ Chrome 已安装${NC}"
fi

# 7. 安装 GitHub Desktop（可选）
echo ""
echo -e "${BLUE}[7/8] 检查 GitHub Desktop（可选）...${NC}"
read -p "是否安装 GitHub Desktop? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ ! -d "/Applications/GitHub Desktop.app" ]; then
        echo -e "${YELLOW}⚠️  GitHub Desktop 未安装，正在安装...${NC}"
        brew install --cask github
        echo -e "${GREEN}✅ GitHub Desktop 安装完成${NC}"
    else
        echo -e "${GREEN}✅ GitHub Desktop 已安装${NC}"
    fi
else
    echo -e "${YELLOW}⏭️  跳过 GitHub Desktop${NC}"
fi

# 8. 安装 Rectangle（可选）
echo ""
echo -e "${BLUE}[8/8] 检查 Rectangle（可选）...${NC}"
read -p "是否安装 Rectangle（窗口管理工具）? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ ! -d "/Applications/Rectangle.app" ]; then
        echo -e "${YELLOW}⚠️  Rectangle 未安装，正在安装...${NC}"
        brew install --cask rectangle
        echo -e "${GREEN}✅ Rectangle 安装完成${NC}"
    else
        echo -e "${GREEN}✅ Rectangle 已安装${NC}"
    fi
else
    echo -e "${YELLOW}⏭️  跳过 Rectangle${NC}"
fi

# 总结
echo ""
echo "=========================================="
echo -e "${GREEN}✅ 安装完成！${NC}"
echo "=========================================="
echo ""
echo "已安装的软件："
echo "  ✅ Homebrew"
echo "  ✅ Git"
echo "  ✅ nvm"
echo "  ✅ Cursor"
echo "  ✅ iTerm2"
echo "  ✅ Chrome"
echo ""
echo "下一步操作："
echo ""
echo "1. 如果 nvm 刚安装，请重启终端或运行："
echo "   source ~/.zshrc"
echo ""
echo "2. 安装 Node.js："
echo "   nvm install 20"
echo "   nvm use 20"
echo "   nvm alias default 20"
echo ""
echo "3. 配置 Git（如果还没有）："
echo "   git config --global user.name \"你的名字\""
echo "   git config --global user.email \"你的邮箱\""
echo ""
echo "4. 安装 Oh My Zsh（可选，美化终端）："
echo "   sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
echo ""
echo "=========================================="
echo ""



















