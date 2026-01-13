#!/bin/bash

# 检查 OSS 环境变量脚本
echo "=== 检查 OSS 环境变量 ==="
echo ""

# 检查本地 .env 文件
if [ -f ".env" ]; then
    echo "📄 检查本地 .env 文件:"
    echo ""
    
    if grep -q "^OSS_ACCESS_KEY_ID=" .env; then
        oss_id=$(grep "^OSS_ACCESS_KEY_ID=" .env | cut -d'=' -f2 | xargs)
        if [ -n "$oss_id" ] && [ "$oss_id" != "your_access_key_id" ]; then
            echo "✅ OSS_ACCESS_KEY_ID: 已配置 (${oss_id:0:8}...)"
        else
            echo "⚠️  OSS_ACCESS_KEY_ID: 未配置或使用占位符"
        fi
    else
        echo "❌ OSS_ACCESS_KEY_ID: 未找到"
    fi
    
    if grep -q "^OSS_ACCESS_KEY_SECRET=" .env; then
        oss_secret=$(grep "^OSS_ACCESS_KEY_SECRET=" .env | cut -d'=' -f2 | xargs)
        if [ -n "$oss_secret" ] && [ "$oss_secret" != "your_access_key_secret" ]; then
            echo "✅ OSS_ACCESS_KEY_SECRET: 已配置"
        else
            echo "⚠️  OSS_ACCESS_KEY_SECRET: 未配置或使用占位符"
        fi
    else
        echo "❌ OSS_ACCESS_KEY_SECRET: 未找到"
    fi
    
    if grep -q "^OSS_REGION=" .env; then
        oss_region=$(grep "^OSS_REGION=" .env | cut -d'=' -f2 | xargs)
        echo "✅ OSS_REGION: $oss_region"
    else
        echo "⚠️  OSS_REGION: 未找到（将使用默认值）"
    fi
    
    if grep -q "^OSS_BUCKET=" .env; then
        oss_bucket=$(grep "^OSS_BUCKET=" .env | cut -d'=' -f2 | xargs)
        echo "✅ OSS_BUCKET: $oss_bucket"
    else
        echo "⚠️  OSS_BUCKET: 未找到（将使用默认值）"
    fi
else
    echo "❌ .env 文件不存在"
fi

echo ""
echo "=== 检查运行时环境变量 ==="
echo ""

if [ -n "$OSS_ACCESS_KEY_ID" ]; then
    echo "✅ OSS_ACCESS_KEY_ID: 已设置 (${OSS_ACCESS_KEY_ID:0:8}...)"
else
    echo "❌ OSS_ACCESS_KEY_ID: 未设置"
fi

if [ -n "$OSS_ACCESS_KEY_SECRET" ]; then
    echo "✅ OSS_ACCESS_KEY_SECRET: 已设置"
else
    echo "❌ OSS_ACCESS_KEY_SECRET: 未设置"
fi

if [ -n "$OSS_REGION" ]; then
    echo "✅ OSS_REGION: $OSS_REGION"
else
    echo "⚠️  OSS_REGION: 未设置（将使用默认值）"
fi

if [ -n "$OSS_BUCKET" ]; then
    echo "✅ OSS_BUCKET: $OSS_BUCKET"
else
    echo "⚠️  OSS_BUCKET: 未设置（将使用默认值）"
fi

echo ""
echo "=== 检查结果 ==="
echo ""
echo "如果是在 Railway 上运行，请确保在 Railway 项目设置中添加了以下环境变量："
echo "  - OSS_ACCESS_KEY_ID"
echo "  - OSS_ACCESS_KEY_SECRET"
echo "  - OSS_REGION"
echo "  - OSS_BUCKET"
echo ""
echo "如果是在本地运行，请确保 .env 文件中配置了这些变量。"
