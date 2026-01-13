#!/bin/bash

# OSS 配置检查脚本
echo "=== OSS 配置检查 ==="
echo ""

envFile=".env"
if [ ! -f "$envFile" ]; then
    echo "❌ .env 文件不存在！"
    exit 1
fi

echo "✅ .env 文件存在"
echo ""

# 检查 OSS 配置
allPassed=true

# 检查每个配置项
configs=("OSS_REGION" "OSS_ACCESS_KEY_ID" "OSS_ACCESS_KEY_SECRET" "OSS_BUCKET")

for configName in "${configs[@]}"; do
    found=false
    commented=false
    hasValue=false
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*"$configName"[[:space:]]*= ]]; then
            found=true
            if [[ "$line" =~ ^[[:space:]]*# ]]; then
                commented=true
                echo "❌ $configName : 已被注释（需要取消注释）"
                allPassed=false
            else
                value=$(echo "$line" | cut -d'=' -f2 | xargs)
                if [ -z "$value" ] || [[ "$value" =~ your_|placeholder ]]; then
                    echo "⚠️  $configName : 已配置但值为空或占位符"
                    echo "   当前值: $value"
                    allPassed=false
                else
                    if [[ "$configName" =~ SECRET|KEY ]]; then
                        displayValue="${value:0:8}***"
                    else
                        displayValue="$value"
                    fi
                    echo "✅ $configName : 已正确配置"
                    echo "   值: $displayValue"
                    hasValue=true
                fi
            fi
            break
        fi
    done < "$envFile"
    
    if [ "$found" = false ]; then
        echo "❌ $configName : 未找到配置项"
        allPassed=false
    fi
done

echo ""
echo "=== 检查结果 ==="

if [ "$allPassed" = true ]; then
    echo "✅ 所有必需的 OSS 配置项都已正确配置！"
    echo ""
    echo "下一步："
    echo "1. 重启后端服务: npm run dev"
    echo "2. 测试图片上传功能"
else
    echo "❌ 配置不完整，请按照以下步骤修复："
    echo ""
    echo "修复步骤："
    echo "1. 打开 .env 文件"
    echo "2. 找到 OSS 配置部分（以 # 阿里云OSS配置 开头）"
    echo "3. 取消注释（删除行首的 # 号）"
    echo "4. 填入真实的配置值："
    echo "   - OSS_REGION=oss-cn-hangzhou"
    echo "   - OSS_ACCESS_KEY_ID=你的AccessKey_ID"
    echo "   - OSS_ACCESS_KEY_SECRET=你的AccessKey_Secret"
    echo "   - OSS_BUCKET=venues-images"
    echo ""
    echo "详细配置说明请查看: OSS_SETUP.md 或 OSS_CONFIG_GUIDE.md"
fi
