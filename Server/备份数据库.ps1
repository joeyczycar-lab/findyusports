# 简单的数据库备份脚本
Write-Host "=== 数据库备份 ===" -ForegroundColor Cyan

# 进入 API 目录
Set-Location api

# 启动数据库
Write-Host "启动数据库..." -ForegroundColor Yellow
docker compose up -d

# 等待数据库启动
Write-Host "等待数据库启动（10秒）..." -ForegroundColor Gray
Start-Sleep -Seconds 10

# 创建备份
Write-Host "正在备份..." -ForegroundColor Green
$backupFile = "..\backup_venues.sql"
docker exec venues_pg pg_dump -U postgres venues | Out-File -FilePath $backupFile -Encoding UTF8

# 检查结果
if (Test-Path $backupFile) {
    $size = (Get-Item $backupFile).Length
    Write-Host ""
    Write-Host "✅ 备份成功！" -ForegroundColor Green
    Write-Host "文件位置: $((Resolve-Path $backupFile).Path)" -ForegroundColor Cyan
    Write-Host "文件大小: $([math]::Round($size/1KB, 2)) KB" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "❌ 备份失败" -ForegroundColor Red
    Write-Host "请检查数据库容器是否运行: docker ps -a | findstr venues_pg" -ForegroundColor Yellow
}

Set-Location ..













