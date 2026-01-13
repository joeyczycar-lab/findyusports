# 检查 Docker Volume 数据是否还在
Write-Host "=== 检查 Docker 数据 ===" -ForegroundColor Cyan
Write-Host ""

# 检查 Docker 数据目录
$dockerDataPath = "$env:LOCALAPPDATA\Docker"
$wslDataPath = "$env:USERPROFILE\AppData\Local\Docker"

Write-Host "检查 Docker 数据目录..." -ForegroundColor Yellow
Write-Host ""

if (Test-Path $dockerDataPath) {
    Write-Host "✅ 找到 Docker 数据目录: $dockerDataPath" -ForegroundColor Green
    $size = (Get-ChildItem $dockerDataPath -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1GB
    Write-Host "   数据大小: $([math]::Round($size, 2)) GB" -ForegroundColor Cyan
} else {
    Write-Host "❌ 未找到 Docker 数据目录: $dockerDataPath" -ForegroundColor Red
}

if (Test-Path $wslDataPath) {
    Write-Host "✅ 找到 WSL Docker 数据目录: $wslDataPath" -ForegroundColor Green
    $size = (Get-ChildItem $wslDataPath -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1GB
    Write-Host "   数据大小: $([math]::Round($size, 2)) GB" -ForegroundColor Cyan
} else {
    Write-Host "❌ 未找到 WSL Docker 数据目录: $wslDataPath" -ForegroundColor Red
}

Write-Host ""
Write-Host "📋 下一步：" -ForegroundColor Yellow
Write-Host "   如果找到数据目录，重新安装 Docker Desktop 后数据应该还在" -ForegroundColor White
Write-Host "   下载地址: https://www.docker.com/products/docker-desktop/" -ForegroundColor Cyan












