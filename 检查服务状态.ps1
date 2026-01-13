# 检查前后端服务状态脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "检查服务状态" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查前端服务（端口 3000）
Write-Host "[1/2] 检查前端服务（端口 3000）..." -ForegroundColor Yellow
$frontendPort = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
if ($frontendPort) {
    $frontendProcess = Get-Process -Id ($frontendPort.OwningProcess | Select-Object -First 1) -ErrorAction SilentlyContinue
    Write-Host "   状态: 运行中" -ForegroundColor Green
    Write-Host "   进程: $($frontendProcess.ProcessName) (PID: $($frontendPort.OwningProcess | Select-Object -First 1))" -ForegroundColor White
    Write-Host "   地址: http://localhost:3000" -ForegroundColor White
    
    # 测试前端服务
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:3000" -TimeoutSec 3 -UseBasicParsing -ErrorAction Stop
        Write-Host "   健康检查: 正常 (状态码: $($response.StatusCode))" -ForegroundColor Green
    } catch {
        Write-Host "   健康检查: 无法访问" -ForegroundColor Red
    }
} else {
    Write-Host "   状态: 未运行" -ForegroundColor Red
    Write-Host "   建议: 运行 .\启动前端服务.ps1" -ForegroundColor Yellow
}
Write-Host ""

# 检查后端服务（端口 4000）
Write-Host "[2/2] 检查后端服务（端口 4000）..." -ForegroundColor Yellow
$backendPort = Get-NetTCPConnection -LocalPort 4000 -ErrorAction SilentlyContinue
if ($backendPort) {
    $backendProcess = Get-Process -Id ($backendPort.OwningProcess | Select-Object -First 1) -ErrorAction SilentlyContinue
    Write-Host "   状态: 运行中" -ForegroundColor Green
    Write-Host "   进程: $($backendProcess.ProcessName) (PID: $($backendPort.OwningProcess | Select-Object -First 1))" -ForegroundColor White
    Write-Host "   地址: http://localhost:4000" -ForegroundColor White
    
    # 测试后端服务
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:4000/health" -TimeoutSec 3 -UseBasicParsing -ErrorAction Stop
        Write-Host "   健康检查: 正常 (状态码: $($response.StatusCode))" -ForegroundColor Green
    } catch {
        Write-Host "   健康检查: 无法访问" -ForegroundColor Red
        Write-Host "   错误: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "   状态: 未运行" -ForegroundColor Red
    Write-Host "   建议: 运行 .\启动后端服务.ps1" -ForegroundColor Yellow
}
Write-Host ""

# 总结
Write-Host "========================================" -ForegroundColor Cyan
if ($frontendPort -and $backendPort) {
    Write-Host "所有服务运行正常！" -ForegroundColor Green
    Write-Host ""
    Write-Host "访问地址:" -ForegroundColor Cyan
    Write-Host "   - 前端: http://localhost:3000" -ForegroundColor White
    Write-Host "   - 后端: http://localhost:4000" -ForegroundColor White
} else {
    Write-Host "部分服务未运行，请启动缺失的服务" -ForegroundColor Yellow
}
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

pause
