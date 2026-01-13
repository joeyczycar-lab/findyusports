# 启动后端服务脚本
# 检查并释放端口 4000，然后启动 NestJS 后端服务

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "启动后端服务" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 切换到项目根目录
$rootDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $rootDir

# 检查端口 4000 是否被占用
Write-Host "[1/3] 检查端口 4000..." -ForegroundColor Yellow
$port4000 = Get-NetTCPConnection -LocalPort 4000 -ErrorAction SilentlyContinue
if ($port4000) {
    Write-Host "警告: 端口 4000 已被占用" -ForegroundColor Yellow
    $processId = $port4000.OwningProcess | Select-Object -First 1
    $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "   正在停止进程: $($process.ProcessName) (PID: $processId)" -ForegroundColor Yellow
        Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Write-Host "成功: 已停止占用端口 4000 的进程" -ForegroundColor Green
    }
} else {
    Write-Host "成功: 端口 4000 可用" -ForegroundColor Green
}
Write-Host ""

# 切换到后端目录
$backendDir = Join-Path $rootDir "Server\api"
if (-not (Test-Path $backendDir)) {
    Write-Host "错误: 后端目录不存在: $backendDir" -ForegroundColor Red
    pause
    exit 1
}

Set-Location $backendDir
Write-Host "[2/3] 当前目录: $(Get-Location)" -ForegroundColor Yellow
Write-Host ""

# 检查 node_modules
if (-not (Test-Path "node_modules")) {
    Write-Host "[3/3] 检测到 node_modules 不存在，正在安装依赖..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "错误: 依赖安装失败" -ForegroundColor Red
        pause
        exit 1
    }
    Write-Host ""
} else {
    Write-Host "[3/3] 依赖已安装" -ForegroundColor Green
    Write-Host ""
}

# 启动开发服务器
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "正在启动 NestJS 后端服务..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "后端服务将在以下地址运行:" -ForegroundColor Green
Write-Host "   - API: http://localhost:4000" -ForegroundColor White
Write-Host "   - Health: http://localhost:4000/health" -ForegroundColor White
Write-Host ""
Write-Host "按 Ctrl+C 可以停止服务器" -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

npm run dev
