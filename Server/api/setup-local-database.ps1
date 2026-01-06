# 配置本地数据库脚本
Write-Host "=== 配置本地数据库 ===" -ForegroundColor Cyan
Write-Host ""

# 检查 Docker 是否可用
Write-Host "🔍 检查 Docker..." -ForegroundColor Yellow
$dockerAvailable = $false
try {
    $dockerVersion = docker --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker 已安装: $dockerVersion" -ForegroundColor Green
        $dockerAvailable = $true
    }
} catch {
    Write-Host "❌ Docker 未安装或未在 PATH 中" -ForegroundColor Red
    Write-Host ""
    Write-Host "请先安装 Docker Desktop:" -ForegroundColor Yellow
    Write-Host "  1. 访问: https://www.docker.com/products/docker-desktop/" -ForegroundColor White
    Write-Host "  2. 下载并安装 Docker Desktop" -ForegroundColor White
    Write-Host "  3. 重启电脑后再次运行此脚本" -ForegroundColor White
    exit 1
}

# 检查 Docker 是否运行
Write-Host "🔍 检查 Docker 服务状态..." -ForegroundColor Yellow
try {
    docker ps > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker 服务正在运行" -ForegroundColor Green
    } else {
        Write-Host "❌ Docker 服务未运行" -ForegroundColor Red
        Write-Host "请启动 Docker Desktop 应用" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "❌ 无法连接到 Docker 服务" -ForegroundColor Red
    Write-Host "请确保 Docker Desktop 已启动" -ForegroundColor Yellow
    exit 1
}

# 创建 .env 文件
Write-Host ""
Write-Host "📝 配置 .env 文件..." -ForegroundColor Yellow

$envFile = ".env"
$envContent = @"
# 服务器配置
PORT=4000

# 本地数据库配置（Docker）
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=postgres
DB_NAME=venues

# 如果使用 Railway 数据库，取消下面的注释并注释掉上面的本地配置
# DATABASE_URL=postgresql://postgres:password@hostname:port/railway
# DB_SSL=true

# JWT 配置
JWT_SECRET=$(-join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_}))

# 阿里云OSS配置（可选）
# OSS_REGION=oss-cn-hangzhou
# OSS_ACCESS_KEY_ID=your_access_key_id
# OSS_ACCESS_KEY_SECRET=your_access_key_secret
# OSS_BUCKET=venues-images
# OSS_HOTLINK_SECRET=your_hotlink_secret_key
"@

if (Test-Path $envFile) {
    Write-Host "⚠️  .env 文件已存在" -ForegroundColor Yellow
    $overwrite = Read-Host "是否覆盖？(y/n)"
    if ($overwrite -ne "y") {
        Write-Host "已取消操作" -ForegroundColor Yellow
        exit 0
    }
}

$envContent | Out-File -FilePath $envFile -Encoding utf8 -NoNewline
Write-Host "✅ .env 文件已创建" -ForegroundColor Green

# 启动数据库容器
Write-Host ""
Write-Host "🐳 启动数据库容器..." -ForegroundColor Yellow

$containerName = "venues_pg"
$containerExists = docker ps -a --filter "name=$containerName" --format "{{.Names}}" 2>&1

if ($containerExists -match $containerName) {
    Write-Host "   容器已存在，检查运行状态..." -ForegroundColor Gray
    $containerRunning = docker ps --filter "name=$containerName" --format "{{.Names}}" 2>&1
    if ($containerRunning -match $containerName) {
        Write-Host "✅ 数据库容器正在运行" -ForegroundColor Green
    } else {
        Write-Host "   启动容器..." -ForegroundColor Gray
        docker start $containerName 2>&1 | Out-Null
        Start-Sleep -Seconds 3
        Write-Host "✅ 数据库容器已启动" -ForegroundColor Green
    }
} else {
    Write-Host "   创建并启动容器..." -ForegroundColor Gray
    docker compose up -d 2>&1 | Out-Null
    Start-Sleep -Seconds 5
    Write-Host "✅ 数据库容器已创建并启动" -ForegroundColor Green
}

# 等待数据库完全启动
Write-Host "   等待数据库完全启动..." -ForegroundColor Gray
$maxRetries = 12
$retryCount = 0
$dbReady = $false

while ($retryCount -lt $maxRetries -and -not $dbReady) {
    Start-Sleep -Seconds 2
    try {
        $result = docker exec $containerName pg_isready -U postgres 2>&1
        if ($LASTEXITCODE -eq 0) {
            $dbReady = $true
        }
    } catch {
        # 继续重试
    }
    $retryCount++
}

if ($dbReady) {
    Write-Host "✅ 数据库已就绪" -ForegroundColor Green
} else {
    Write-Host "⚠️  数据库可能还在启动中，请稍等..." -ForegroundColor Yellow
}

# 初始化 PostGIS 扩展
Write-Host ""
Write-Host "🗺️  初始化 PostGIS 扩展..." -ForegroundColor Yellow
try {
    docker exec $containerName psql -U postgres -d venues -c "CREATE EXTENSION IF NOT EXISTS postgis;" 2>&1 | Out-Null
    Write-Host "✅ PostGIS 扩展已初始化" -ForegroundColor Green
} catch {
    Write-Host "⚠️  PostGIS 初始化可能失败，但可以继续" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📋 下一步操作：" -ForegroundColor Yellow
Write-Host "   1. 运行数据库迁移：" -ForegroundColor White
Write-Host "      npm run migration:run" -ForegroundColor Gray
Write-Host ""
Write-Host "   2. 启动后端服务：" -ForegroundColor White
Write-Host "      npm run dev" -ForegroundColor Gray
Write-Host ""
Write-Host "   3. 前端默认连接到: http://localhost:4000" -ForegroundColor White
Write-Host ""





