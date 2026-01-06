# 代理配置脚本
Write-Host "=== 代理服务器配置 ===" -ForegroundColor Cyan
Write-Host ""

# 检查当前代理设置
Write-Host "当前代理设置:" -ForegroundColor Yellow
netsh winhttp show proxy
Write-Host ""

# 获取代理信息
Write-Host "请输入代理服务器信息:" -ForegroundColor Green
Write-Host ""
$proxyHost = Read-Host "代理地址 (例如: 127.0.0.1)"
$proxyPort = Read-Host "代理端口 (例如: 7890)"

if ([string]::IsNullOrWhiteSpace($proxyHost) -or [string]::IsNullOrWhiteSpace($proxyPort)) {
    Write-Host "代理地址和端口不能为空！" -ForegroundColor Red
    exit 1
}

$proxyServer = "$proxyHost`:$proxyPort"

Write-Host ""
Write-Host "配置代理: $proxyServer" -ForegroundColor Yellow

# 设置系统代理
try {
    netsh winhttp set proxy proxy-server="http=$proxyServer;https=$proxyServer" bypass-list="localhost;127.0.0.1;*.local" | Out-Null
    Write-Host "[OK] 系统代理已设置" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] 设置代理失败: $_" -ForegroundColor Red
    exit 1
}

# 设置环境变量（当前会话）
$env:HTTP_PROXY = "http://$proxyServer"
$env:HTTPS_PROXY = "http://$proxyServer"
$env:NO_PROXY = "localhost,127.0.0.1,*.local"

Write-Host "[OK] 环境变量已设置（当前会话）" -ForegroundColor Green

# 验证设置
Write-Host ""
Write-Host "验证代理设置:" -ForegroundColor Yellow
netsh winhttp show proxy

Write-Host ""
Write-Host "测试连接..." -ForegroundColor Yellow

# 测试 Google
try {
    $response = Invoke-WebRequest -Uri "https://www.google.com" -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
    Write-Host "[OK] Google 可以访问" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Google 无法访问: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "请检查:" -ForegroundColor Yellow
    Write-Host "  1. 代理服务器是否正在运行" -ForegroundColor White
    Write-Host "  2. 代理地址和端口是否正确" -ForegroundColor White
    Write-Host "  3. 代理是否需要认证" -ForegroundColor White
}

Write-Host ""
Write-Host "配置完成！" -ForegroundColor Green
Write-Host ""
Write-Host "注意: 环境变量只在当前 PowerShell 会话有效" -ForegroundColor Yellow
Write-Host "如果需要永久设置，请手动添加到系统环境变量" -ForegroundColor Yellow



