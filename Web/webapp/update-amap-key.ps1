# 更新高德地图 API Key 的简单脚本

$envFile = ".env.local"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "更新高德地图 API Key" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查文件是否存在
if (-not (Test-Path $envFile)) {
    Write-Host "错误: 找不到 $envFile 文件" -ForegroundColor Red
    Write-Host "请先运行 setup-amap-simple.bat 创建配置文件" -ForegroundColor Yellow
    exit 1
}

# 获取 API Key
Write-Host "请输入你的高德地图 API Key：" -ForegroundColor White
$amapKey = Read-Host "NEXT_PUBLIC_AMAP_KEY"

if ([string]::IsNullOrWhiteSpace($amapKey)) {
    Write-Host "错误: API Key 不能为空！" -ForegroundColor Red
    exit 1
}

# 读取现有文件内容
$content = Get-Content $envFile -Raw -Encoding UTF8

# 更新或添加 NEXT_PUBLIC_AMAP_KEY
if ($content -match "NEXT_PUBLIC_AMAP_KEY=") {
    $content = $content -replace "NEXT_PUBLIC_AMAP_KEY=.*", "NEXT_PUBLIC_AMAP_KEY=$amapKey"
} else {
    $content = "NEXT_PUBLIC_AMAP_KEY=$amapKey`r`n" + $content
}

# 确保 NEXT_PUBLIC_API_BASE 只出现一次
$apiBase = "http://localhost:4000"
if ($content -match "NEXT_PUBLIC_API_BASE=([^`r`n]+)") {
    $apiBase = $matches[1]
}
$content = $content -replace "NEXT_PUBLIC_API_BASE=.*`r?`n", ""
$content = $content.Trim() + "`r`n`r`nNEXT_PUBLIC_API_BASE=$apiBase`r`n"

# 写入文件
try {
    [System.IO.File]::WriteAllText((Resolve-Path .).Path + "\$envFile", $content.Trim(), [System.Text.Encoding]::UTF8)
    Write-Host ""
    Write-Host "成功！已更新 $envFile 文件" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步：" -ForegroundColor Cyan
    Write-Host "1. 重启开发服务器（如果正在运行）" -ForegroundColor White
    Write-Host "2. 访问 http://localhost:3000/admin/add-venue 测试地图" -ForegroundColor White
    Write-Host ""
} catch {
    Write-Host "错误: 更新文件失败 - $_" -ForegroundColor Red
    exit 1
}




















