# 配置 Railway 后端地址脚本

$envFile = ".env.local"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "配置 Railway 后端地址" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否已存在 .env.local
$existingContent = ""
if (Test-Path $envFile) {
    $existingContent = Get-Content $envFile -Raw -Encoding UTF8
    Write-Host "发现已存在的 $envFile 文件" -ForegroundColor Yellow
    Write-Host ""
}

# 获取 Railway 后端地址
Write-Host "请输入你的 Railway 后端地址：" -ForegroundColor White
Write-Host "（例如：https://findyusports-production.up.railway.app）" -ForegroundColor Gray
Write-Host "（或者：https://findyusports-api-production.up.railway.app）" -ForegroundColor Gray
$railwayUrl = Read-Host "Railway 后端地址"

if ([string]::IsNullOrWhiteSpace($railwayUrl)) {
    Write-Host "后端地址不能为空！" -ForegroundColor Red
    exit 1
}

# 确保 URL 格式正确
if (-not $railwayUrl.StartsWith("http://") -and -not $railwayUrl.StartsWith("https://")) {
    $railwayUrl = "https://" + $railwayUrl
}

# 更新或创建 .env.local
$lines = @()

# 如果文件已存在，保留其他配置
if ($existingContent) {
    $existingLines = $existingContent -split "`r?`n"
    $foundApiBase = $false
    
    foreach ($line in $existingLines) {
        if ($line -match "^NEXT_PUBLIC_API_BASE=") {
            $lines += "NEXT_PUBLIC_API_BASE=$railwayUrl"
            $foundApiBase = $true
        } else {
            $lines += $line
        }
    }
    
    if (-not $foundApiBase) {
        $lines += ""
        $lines += "# 后端 API 地址（Railway）"
        $lines += "NEXT_PUBLIC_API_BASE=$railwayUrl"
    }
} else {
    # 创建新文件
    $lines = @(
        "# 后端 API 地址（Railway）",
        "NEXT_PUBLIC_API_BASE=$railwayUrl"
    )
}

# 写入文件
try {
    $content = $lines -join "`r`n"
    [System.IO.File]::WriteAllText((Resolve-Path .).Path + "\$envFile", $content.Trim() + "`r`n", [System.Text.Encoding]::UTF8)
    Write-Host ""
    Write-Host "配置成功！已更新 $envFile 文件" -ForegroundColor Green
    Write-Host ""
    Write-Host "配置的后端地址: $railwayUrl" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "下一步：" -ForegroundColor Yellow
    Write-Host "1. 重启前端开发服务器（如果正在运行）" -ForegroundColor White
    Write-Host "2. 刷新浏览器页面" -ForegroundColor White
    Write-Host ""
} catch {
    Write-Host "更新文件失败：$_" -ForegroundColor Red
    exit 1
}

pause
