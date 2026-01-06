# 图片文件传输脚本
# 用途：将项目中的图片文件打包，方便传输到 Mac

Write-Host "=== 图片文件传输工具 ===" -ForegroundColor Cyan
Write-Host ""

$sourceDir = "F:\Findyu"
$outputDir = "$env:USERPROFILE\Desktop\FindyuImages"

# 创建输出目录
Write-Host "📁 创建输出目录..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

# 查找并复制图片文件
Write-Host "🔍 查找图片文件..." -ForegroundColor Yellow

$imageFiles = @()

# 前端图片
$webImages = Get-ChildItem "$sourceDir\Web\webapp\public\*.jpg" -ErrorAction SilentlyContinue
if ($webImages) {
    Write-Host "   找到前端图片: $($webImages.Count) 个文件" -ForegroundColor Green
    foreach ($img in $webImages) {
        Copy-Item $img.FullName -Destination "$outputDir\$($img.Name)" -Force
        $imageFiles += $img
    }
}

# pic 文件夹
if (Test-Path "$sourceDir\pic") {
    $picFiles = Get-ChildItem "$sourceDir\pic\*" -Include *.jpg,*.png,*.jpeg,*.gif -ErrorAction SilentlyContinue
    if ($picFiles) {
        Write-Host "   找到 pic 文件夹图片: $($picFiles.Count) 个文件" -ForegroundColor Green
        New-Item -ItemType Directory -Path "$outputDir\pic" -Force | Out-Null
        foreach ($img in $picFiles) {
            Copy-Item $img.FullName -Destination "$outputDir\pic\$($img.Name)" -Force
            $imageFiles += $img
        }
    }
}

if ($imageFiles.Count -eq 0) {
    Write-Host "❌ 未找到图片文件" -ForegroundColor Red
    exit 1
}

# 计算总大小
$totalSize = ($imageFiles | Measure-Object -Property Length -Sum).Sum / 1MB
Write-Host ""
Write-Host "📊 文件统计:" -ForegroundColor Cyan
Write-Host "   文件数量: $($imageFiles.Count)" -ForegroundColor White
Write-Host "   总大小: $([math]::Round($totalSize, 2)) MB" -ForegroundColor White

# 创建压缩包
Write-Host ""
Write-Host "📦 创建压缩包..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipFile = "$outputDir\FindyuImages_$timestamp.zip"

Compress-Archive -Path "$outputDir\*" -DestinationPath $zipFile -Force

$zipSize = (Get-Item $zipFile).Length / 1MB
Write-Host "✅ 压缩完成！" -ForegroundColor Green
Write-Host "   压缩包: $zipFile" -ForegroundColor Cyan
Write-Host "   压缩后大小: $([math]::Round($zipSize, 2)) MB" -ForegroundColor Cyan

Write-Host ""
Write-Host "📋 下一步操作：" -ForegroundColor Yellow
Write-Host "   1. 将压缩包传输到 Mac（选择以下任一方式）：" -ForegroundColor White
Write-Host "      - 网盘：上传到百度网盘/OneDrive/Google Drive" -ForegroundColor Gray
Write-Host "      - U盘：复制到 U 盘" -ForegroundColor Gray
Write-Host "      - 微信：发送给文件传输助手（如果文件 < 100MB）" -ForegroundColor Gray
Write-Host ""
Write-Host "   2. 在 Mac 上解压：" -ForegroundColor White
Write-Host "      unzip ~/Downloads/FindyuImages_$timestamp.zip -d ~/Desktop/findyusports/" -ForegroundColor Gray
Write-Host ""
Write-Host "   3. 移动文件到正确位置：" -ForegroundColor White
Write-Host "      cp ~/Desktop/findyusports/FindyuImages/*.jpg ~/Desktop/findyusports/Web/webapp/public/" -ForegroundColor Gray
Write-Host "      cp -r ~/Desktop/findyusports/FindyuImages/pic ~/Desktop/findyusports/" -ForegroundColor Gray
Write-Host ""

# 询问是否打开文件夹
$openFolder = Read-Host "是否打开输出文件夹？(y/n)"
if ($openFolder -eq "y") {
    Start-Process explorer.exe -ArgumentList $outputDir
}



