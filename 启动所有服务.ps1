# 启动所有服务脚本（前端 + 后端）

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "启动所有服务" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$rootDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $rootDir

# 检查并启动后端服务
Write-Host "[1/2] 启动后端服务..." -ForegroundColor Yellow
$backendPort = Get-NetTCPConnection -LocalPort 4000 -ErrorAction SilentlyContinue
if ($backendPort) {
    Write-Host "   后端服务已在运行" -ForegroundColor Green
} else {
    Write-Host "   正在启动后端服务..." -ForegroundColor Yellow
    $backendDir = Join-Path $rootDir "Server\api"
    Set-Location $backendDir
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "Write-Host '后端服务 (端口 4000)' -ForegroundColor Cyan; npm run dev" -WindowStyle Normal
    Start-Sleep -Seconds 3
    Write-Host "   后端服务启动中..." -ForegroundColor Green
}
Write-Host ""

# 检查并启动前端服务
Write-Host "[2/2] 启动前端服务..." -ForegroundColor Yellow
$frontendPort = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
if ($frontendPort) {
    Write-Host "   前端服务已在运行" -ForegroundColor Green
} else {
    Write-Host "   正在启动前端服务..." -ForegroundColor Yellow
    $frontendDir = Join-Path $rootDir "Web\webapp"
    Set-Location $frontendDir
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "Write-Host '前端服务 (端口 3000)' -ForegroundColor Cyan; npm run dev" -WindowStyle Normal
    Start-Sleep -Seconds 3
    Write-Host "   前端服务启动中..." -ForegroundColor Green
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "服务启动完成" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "访问地址:" -ForegroundColor Cyan
Write-Host "   - 前端: http://localhost:3000" -ForegroundColor White
Write-Host "   - 后端: http://localhost:4000" -ForegroundColor White
Write-Host ""
Write-Host "注意: 服务将在新窗口中运行" -ForegroundColor Yellow
Write-Host "      请等待服务完全启动（约 10-20 秒）" -ForegroundColor Yellow
Write-Host ""

pause
