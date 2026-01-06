# Clash Verge 简单配置脚本
Write-Host "=== Clash Verge 代理配置 ===" -ForegroundColor Cyan
Write-Host ""

# 检查 Clash Verge 是否运行
Write-Host "检查 Clash Verge..." -ForegroundColor Yellow
$clashProcess = Get-Process | Where-Object {$_.ProcessName -like "*clash*" -or $_.ProcessName -like "*verge*"}
if ($clashProcess) {
    Write-Host "[OK] Clash Verge 正在运行" -ForegroundColor Green
} else {
    Write-Host "[WARN] 未检测到 Clash Verge 进程" -ForegroundColor Yellow
    Write-Host "请先启动 Clash Verge" -ForegroundColor White
    Write-Host ""
}

# 配置系统代理
Write-Host "配置系统代理..." -ForegroundColor Yellow
Write-Host "使用默认端口: 127.0.0.1:7890" -ForegroundColor Gray

try {
    netsh winhttp set proxy proxy-server="http=127.0.0.1:7890;https=127.0.0.1:7890" bypass-list="localhost;127.0.0.1"
    Write-Host "[OK] 系统代理已设置" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] 设置失败: $_" -ForegroundColor Red
}

# 设置环境变量
Write-Host ""
Write-Host "设置环境变量..." -ForegroundColor Yellow
$env:HTTP_PROXY = "http://127.0.0.1:7890"
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
$env:NO_PROXY = "localhost,127.0.0.1"
Write-Host "[OK] 环境变量已设置" -ForegroundColor Green

# 验证
Write-Host ""
Write-Host "当前代理设置:" -ForegroundColor Cyan
netsh winhttp show proxy

Write-Host ""
Write-Host "=== 重要提示 ===" -ForegroundColor Yellow
Write-Host "1. 确保 Clash Verge 已启动" -ForegroundColor White
Write-Host "2. 在 Clash Verge 中启用 '系统代理' 或 'TUN 模式'" -ForegroundColor White
Write-Host "3. 检查 Clash Verge 的端口设置（默认 7890）" -ForegroundColor White
Write-Host "4. 确保已连接到代理节点" -ForegroundColor White
Write-Host ""



