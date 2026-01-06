# Railway 数据库环境配置脚本
Write-Host "=== Railway 数据库配置向导 ===" -ForegroundColor Cyan
Write-Host ""

# 检查是否已存在 .env 文件
if (Test-Path .env) {
    Write-Host "⚠️  .env 文件已存在" -ForegroundColor Yellow
    $overwrite = Read-Host "是否覆盖现有配置？(y/n)"
    if ($overwrite -ne "y") {
        Write-Host "已取消操作" -ForegroundColor Yellow
        exit 0
    }
}

Write-Host "📋 请按照以下步骤配置：" -ForegroundColor Green
Write-Host ""
Write-Host "1. 登录 Railway: https://railway.app" -ForegroundColor White
Write-Host "2. 找到你的数据库服务" -ForegroundColor White
Write-Host "3. 点击 'Connect' 或 'Variables' 标签页" -ForegroundColor White
Write-Host "4. 复制 DATABASE_URL 或 POSTGRES_URL" -ForegroundColor White
Write-Host ""

# 获取 DATABASE_URL
$databaseUrl = Read-Host "请输入 DATABASE_URL（或按 Enter 跳过）"

if ([string]::IsNullOrWhiteSpace($databaseUrl)) {
    Write-Host "⚠️  未输入 DATABASE_URL，将创建模板文件" -ForegroundColor Yellow
    $databaseUrl = "postgresql://postgres:password@hostname:port/railway"
}

# 生成 JWT_SECRET
Write-Host ""
Write-Host "🔑 生成 JWT_SECRET..." -ForegroundColor Green
$jwtSecret = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_})
Write-Host "   生成的密钥: $jwtSecret" -ForegroundColor Gray

# 创建 .env 文件内容
$envContent = @"
# 服务器配置
PORT=4000

# Railway 数据库配置
DATABASE_URL=$databaseUrl
DB_SSL=true

# JWT 配置
JWT_SECRET=$jwtSecret

# 阿里云OSS配置（可选，如果不需要上传图片可以暂时不配置）
# OSS_REGION=oss-cn-hangzhou
# OSS_ACCESS_KEY_ID=your_access_key_id
# OSS_ACCESS_KEY_SECRET=your_access_key_secret
# OSS_BUCKET=venues-images
# OSS_HOTLINK_SECRET=your_hotlink_secret_key
"@

# 写入文件
$envContent | Out-File -FilePath .env -Encoding utf8 -NoNewline

Write-Host ""
Write-Host "✅ .env 文件已创建！" -ForegroundColor Green
Write-Host ""
Write-Host "📋 下一步操作：" -ForegroundColor Yellow
Write-Host "   1. 检查 .env 文件中的 DATABASE_URL 是否正确" -ForegroundColor White
Write-Host "   2. 在 Railway Query 页面执行: CREATE EXTENSION IF NOT EXISTS postgis;" -ForegroundColor White
Write-Host "   3. 运行数据库迁移: npm run migration:run" -ForegroundColor White
Write-Host "   4. 启动后端服务: npm run dev" -ForegroundColor White
Write-Host ""



