# 数据库备份脚本
# 用途：备份 PostgreSQL 数据库到 SQL 文件，方便迁移到 Mac

Write-Host "=== 数据库备份工具 ===" -ForegroundColor Cyan
Write-Host ""

# 检查 Docker 是否运行
$dockerRunning = docker ps 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker 未运行，请先启动 Docker Desktop" -ForegroundColor Red
    exit 1
}

# 检查数据库容器是否存在
$containerExists = docker ps -a --filter "name=venues_pg" --format "{{.Names}}"
if (-not $containerExists) {
    Write-Host "⚠️  数据库容器不存在，正在启动..." -ForegroundColor Yellow
    cd api
    docker compose up -d
    Start-Sleep -Seconds 5
    cd ..
}

# 检查容器是否运行
$containerRunning = docker ps --filter "name=venues_pg" --format "{{.Names}}"
if (-not $containerRunning) {
    Write-Host "⚠️  数据库容器未运行，正在启动..." -ForegroundColor Yellow
    cd api
    docker compose start db
    Start-Sleep -Seconds 5
    cd ..
}

# 生成备份文件名（带时间戳）
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = "backup_venues_$timestamp.sql"
$backupPath = Join-Path $PSScriptRoot $backupFile

Write-Host "📦 正在备份数据库..." -ForegroundColor Green
Write-Host "   容器: venues_pg" -ForegroundColor Gray
Write-Host "   数据库: venues" -ForegroundColor Gray
Write-Host "   备份文件: $backupFile" -ForegroundColor Gray
Write-Host ""

# 执行备份
docker exec venues_pg pg_dump -U postgres venues > $backupPath 2>&1

if ($LASTEXITCODE -eq 0) {
    $fileSize = (Get-Item $backupPath).Length / 1KB
    Write-Host "✅ 备份成功！" -ForegroundColor Green
    Write-Host "   文件位置: $backupPath" -ForegroundColor Cyan
    Write-Host "   文件大小: $([math]::Round($fileSize, 2)) KB" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📋 下一步操作：" -ForegroundColor Yellow
    Write-Host "   1. 将备份文件复制到 Mac（U盘/网盘/微信文件传输助手）" -ForegroundColor White
    Write-Host "   2. 在 Mac 上恢复数据库：" -ForegroundColor White
    Write-Host "      cd ~/Desktop/findyusports/Server/api" -ForegroundColor Gray
    Write-Host "      docker compose up -d" -ForegroundColor Gray
    Write-Host "      docker exec -i venues_pg psql -U postgres venues < backup_venues_$timestamp.sql" -ForegroundColor Gray
} else {
    Write-Host "❌ 备份失败！" -ForegroundColor Red
    Write-Host "   请检查数据库容器是否正常运行" -ForegroundColor Yellow
    Write-Host "   运行以下命令检查：" -ForegroundColor Yellow
    Write-Host "   docker ps -a | grep venues_pg" -ForegroundColor Gray
}












