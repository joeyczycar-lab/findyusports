# Clash Verge 代理配置脚本
Write-Host "=== Clash Verge 代理配置 ===" -ForegroundColor Cyan
Write-Host ""

# Clash Verge 默认端口
$httpPort = 7890
$socksPort = 7891

Write-Host "Clash Verge 默认端口:" -ForegroundColor Yellow
Write-Host "  HTTP 代理: 127.0.0.1:$httpPort" -ForegroundColor White
Write-Host "  SOCKS5 代理: 127.0.0.1:$socksPort" -ForegroundColor White
Write-Host ""

# 检查 Clash Verge 是否运行
Write-Host "检查 Clash Verge 状态..." -ForegroundColor Yellow

$clashRunning = $false
$processes = Get-Process | Where-Object {$_.ProcessName -like "*clash*" -or $_.ProcessName -like "*verge*"}
if ($processes) {
    Write-Host "[OK] 检测到 Clash Verge 进程" -ForegroundColor Green
    $clashRunning = $true
} else {
    Write-Host "[WARN] 未检测到 Clash Verge 进程" -ForegroundColor Yellow
    Write-Host "请确保 Clash Verge 已启动" -ForegroundColor White
}

# 测试端口
Write-Host ""
Write-Host "测试代理端口..." -ForegroundColor Yellow

$httpAvailable = Test-NetConnection -ComputerName 127.0.0.1 -Port $httpPort -InformationLevel Quiet -WarningAction SilentlyContinue
$socksAvailable = Test-NetConnection -ComputerName 127.0.0.1 -Port $socksPort -InformationLevel Quiet -WarningAction SilentlyContinue

if ($httpAvailable) {
    Write-Host "[OK] HTTP 代理端口 ($httpPort) 可用" -ForegroundColor Green
} else {
    Write-Host "[FAIL] HTTP 代理端口 ($httpPort) 不可用" -ForegroundColor Red
}

if ($socksAvailable) {
    Write-Host "[OK] SOCKS5 代理端口 ($socksPort) 可用" -ForegroundColor Green
} else {
    Write-Host "[WARN] SOCKS5 代理端口 ($socksPort) 不可用" -ForegroundColor Yellow
}

# 配置系统代理
Write-Host ""
Write-Host "配置系统代理..." -ForegroundColor Yellow

if ($httpAvailable) {
    try {
        $proxyServer = "http=127.0.0.1:$httpPort;https=127.0.0.1:$httpPort"
        $bypassList = "localhost;127.0.0.1;*.local"
        netsh winhttp set proxy proxy-server="$proxyServer" bypass-list="$bypassList" | Out-Null
        Write-Host "[OK] 系统代理已设置" -ForegroundColor Green
    } catch {
        Write-Host "[FAIL] 设置系统代理失败: $_" -ForegroundColor Red
    }
} else {
    Write-Host "[WARN] 由于 HTTP 端口不可用，跳过系统代理设置" -ForegroundColor Yellow
}

# 设置环境变量
Write-Host ""
Write-Host "设置环境变量（当前会话）..." -ForegroundColor Yellow

if ($httpAvailable) {
    $env:HTTP_PROXY = "http://127.0.0.1:$httpPort"
    $env:HTTPS_PROXY = "http://127.0.0.1:$httpPort"
    $env:NO_PROXY = "localhost,127.0.0.1,*.local"
    Write-Host "[OK] 环境变量已设置" -ForegroundColor Green
    Write-Host "  HTTP_PROXY=$env:HTTP_PROXY" -ForegroundColor Gray
    Write-Host "  HTTPS_PROXY=$env:HTTPS_PROXY" -ForegroundColor Gray
}

# 验证设置
Write-Host ""
Write-Host "当前代理设置:" -ForegroundColor Cyan
netsh winhttp show proxy

# 测试连接
Write-Host ""
Write-Host "测试连接..." -ForegroundColor Yellow

# 测试 Google
Write-Host "测试 Google..." -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "https://www.google.com" -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
    Write-Host "[OK] Google 可以访问 (状态码: $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Google 无法访问: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Message -like "*无法解析*" -or $_.Exception.Message -like "*DNS*") {
        Write-Host "提示: 可能是 DNS 解析问题，尝试更换 DNS 服务器" -ForegroundColor Yellow
    }
}

# 测试 GitHub
Write-Host "测试 GitHub..." -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "https://www.github.com" -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
    Write-Host "[OK] GitHub 可以访问 (状态码: $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "[WARN] GitHub 无法访问: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== 配置完成 ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "重要提示:" -ForegroundColor Yellow
Write-Host "1. 确保 Clash Verge 已启动并连接到代理服务器" -ForegroundColor White
Write-Host "2. 在 Clash Verge 中检查 '系统代理' 是否已启用" -ForegroundColor White
Write-Host "3. 如果仍然无法访问，检查 Clash Verge 的代理规则和节点状态" -ForegroundColor White
Write-Host "4. 环境变量只在当前 PowerShell 会话有效" -ForegroundColor White
Write-Host ""
