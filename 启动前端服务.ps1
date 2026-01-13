# 启动前端服务脚本
# 检查并释放端口 3000，然后启动 Next.js 开发服务器

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "启动前端服务" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 切换到项目根目录
$rootDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $rootDir

# 检查端口 3000 是否被占用
Write-Host "[1/3] 检查端口 3000..." -ForegroundColor Yellow
$port3000 = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
if ($port3000) {
    Write-Host "警告: 端口 3000 已被占用" -ForegroundColor Yellow
    $processId = $port3000.OwningProcess | Select-Object -First 1
    $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "   正在停止进程: $($process.ProcessName) (PID: $processId)" -ForegroundColor Yellow
        Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Write-Host "成功: 已停止占用端口 3000 的进程" -ForegroundColor Green
    }
} else {
    Write-Host "成功: 端口 3000 可用" -ForegroundColor Green
}
Write-Host ""

# 切换到前端目录
$frontendDir = Join-Path $rootDir "Web\webapp"
if (-not (Test-Path $frontendDir)) {
    Write-Host "错误: 前端目录不存在: $frontendDir" -ForegroundColor Red
    pause
    exit 1
}

Set-Location $frontendDir
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
Write-Host "正在启动 Next.js 开发服务器..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "前端服务将在以下地址运行:" -ForegroundColor Green
Write-Host "   - 主页: http://localhost:3000" -ForegroundColor White
Write-Host "   - 管理页面: http://localhost:3000/admin" -ForegroundColor White
Write-Host "   - 数据分析: http://localhost:3000/admin/analytics" -ForegroundColor White
Write-Host ""
Write-Host "按 Ctrl+C 可以停止服务器" -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

npm run dev
