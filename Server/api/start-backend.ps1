# 启动后端服务脚本
Write-Host "=== 启动后端服务 ===" -ForegroundColor Cyan
Write-Host ""

# 检查数据库容器
Write-Host "检查数据库容器..." -ForegroundColor Yellow
$container = docker ps --filter "name=venues_pg" --format "{{.Names}}" 2>&1
if ($container -match "venues_pg") {
    Write-Host "[OK] 数据库容器正在运行" -ForegroundColor Green
} else {
    Write-Host "[FAIL] 数据库容器未运行，正在启动..." -ForegroundColor Yellow
    docker compose up -d 2>&1 | Out-Null
    Start-Sleep -Seconds 5
    Write-Host "[OK] 数据库容器已启动" -ForegroundColor Green
}

# 检查 .env 文件
Write-Host "检查 .env 配置..." -ForegroundColor Yellow
if (Test-Path .env) {
    Write-Host "[OK] .env 文件存在" -ForegroundColor Green
} else {
    Write-Host "[WARN] .env 文件不存在" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "启动后端服务..." -ForegroundColor Yellow
Write-Host "后端将运行在: http://localhost:4000" -ForegroundColor Cyan
Write-Host "按 Ctrl+C 停止服务" -ForegroundColor Gray
Write-Host ""

# 启动服务
npm run dev



