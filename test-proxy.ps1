# 测试代理连接
Write-Host "=== 测试代理连接 ===" -ForegroundColor Cyan
Write-Host ""

# 测试 Google
Write-Host "测试 Google..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://www.google.com" -TimeoutSec 10 -UseBasicParsing
    Write-Host "[OK] Google 可以访问 (状态码: $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Google 无法访问" -ForegroundColor Red
    Write-Host "错误: $($_.Exception.Message)" -ForegroundColor Gray
}

# 测试 GitHub
Write-Host ""
Write-Host "测试 GitHub..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://www.github.com" -TimeoutSec 10 -UseBasicParsing
    Write-Host "[OK] GitHub 可以访问 (状态码: $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] GitHub 无法访问" -ForegroundColor Red
    Write-Host "错误: $($_.Exception.Message)" -ForegroundColor Gray
}

Write-Host ""



