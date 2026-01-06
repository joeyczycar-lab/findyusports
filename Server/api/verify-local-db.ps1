# 验证本地数据库配置脚本
Write-Host "=== 验证本地数据库配置 ===" -ForegroundColor Cyan
Write-Host ""

# 1. 检查 Docker
Write-Host "1. 检查 Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   [OK] Docker: $dockerVersion" -ForegroundColor Green
    } else {
        Write-Host "   [FAIL] Docker 未运行" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "   [FAIL] Docker 未安装" -ForegroundColor Red
    exit 1
}

# 2. 检查容器
Write-Host "2. 检查数据库容器..." -ForegroundColor Yellow
$container = docker ps --filter "name=venues_pg" --format "{{.Names}}" 2>&1
if ($container -match "venues_pg") {
    Write-Host "   [OK] 数据库容器正在运行" -ForegroundColor Green
} else {
    Write-Host "   [FAIL] 数据库容器未运行，正在启动..." -ForegroundColor Yellow
    docker compose up -d 2>&1 | Out-Null
    Start-Sleep -Seconds 5
    $container = docker ps --filter "name=venues_pg" --format "{{.Names}}" 2>&1
    if ($container -match "venues_pg") {
        Write-Host "   [OK] 数据库容器已启动" -ForegroundColor Green
    } else {
        Write-Host "   [FAIL] 无法启动数据库容器" -ForegroundColor Red
        exit 1
    }
}

# 3. 检查数据库连接
Write-Host "3. 检查数据库连接..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
$dbReady = docker exec venues_pg pg_isready -U postgres 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "   [OK] 数据库已就绪" -ForegroundColor Green
} else {
    Write-Host "   [FAIL] 数据库未就绪" -ForegroundColor Red
    exit 1
}

# 4. 检查 PostGIS
Write-Host "4. 检查 PostGIS 扩展..." -ForegroundColor Yellow
$postgis = docker exec venues_pg psql -U postgres -d venues -t -c "SELECT COUNT(*) FROM pg_extension WHERE extname='postgis';" 2>&1
if ($postgis -match "1") {
    Write-Host "   [OK] PostGIS 扩展已安装" -ForegroundColor Green
} else {
    Write-Host "   [WARN] PostGIS 未安装，正在安装..." -ForegroundColor Yellow
    docker exec venues_pg psql -U postgres -d venues -c "CREATE EXTENSION IF NOT EXISTS postgis;" 2>&1 | Out-Null
    Write-Host "   [OK] PostGIS 已安装" -ForegroundColor Green
}

# 5. 检查表
Write-Host "5. 检查数据库表..." -ForegroundColor Yellow
$tables = docker exec venues_pg psql -U postgres -d venues -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public';" 2>&1
$tableCount = [int]($tables -replace '\s','')
if ($tableCount -gt 0) {
    Write-Host "   [OK] 找到 $tableCount 个表" -ForegroundColor Green
} else {
    Write-Host "   [WARN] 数据库表为空，需要运行迁移" -ForegroundColor Yellow
    Write-Host "   运行: npm run migration:run" -ForegroundColor Gray
}

# 6. 检查 .env 文件
Write-Host "6. 检查 .env 配置..." -ForegroundColor Yellow
if (Test-Path .env) {
    $envContent = Get-Content .env -Raw
    if ($envContent -match "DB_HOST=localhost") {
        Write-Host "   [OK] .env 配置为本地数据库" -ForegroundColor Green
    } else {
        Write-Host "   [WARN] .env 可能配置了云数据库" -ForegroundColor Yellow
    }
} else {
    Write-Host "   [FAIL] .env 文件不存在" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== 验证完成 ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "  1. 如果表为空，运行: npm run migration:run" -ForegroundColor White
Write-Host "  2. 启动后端: npm run dev" -ForegroundColor White
Write-Host "  3. 前端默认连接到: http://localhost:4000" -ForegroundColor White
Write-Host ""




