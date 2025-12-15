# 创建 .env.local 文件的简单脚本

$envFile = ".env.local"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "创建高德地图配置文件" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否已存在
if (Test-Path $envFile) {
    Write-Host "发现已存在的 $envFile 文件" -ForegroundColor Yellow
    Write-Host ""
    $overwrite = Read-Host "是否覆盖？(y/N)"
    if ($overwrite -ne "y" -and $overwrite -ne "Y") {
        Write-Host "已取消操作" -ForegroundColor Yellow
        exit
    }
}

# 获取 API Key
Write-Host ""
Write-Host "请输入你的高德地图 API Key：" -ForegroundColor White
Write-Host "（如果还没有，请访问：https://console.amap.com/dev/key/app）" -ForegroundColor Gray
$amapKey = Read-Host "NEXT_PUBLIC_AMAP_KEY"

if ([string]::IsNullOrWhiteSpace($amapKey)) {
    Write-Host "API Key 不能为空！" -ForegroundColor Red
    exit 1
}

# 获取后端 API 地址
Write-Host ""
Write-Host "请输入后端 API 地址（默认：http://localhost:4000）：" -ForegroundColor White
$apiBase = Read-Host "NEXT_PUBLIC_API_BASE"
if ([string]::IsNullOrWhiteSpace($apiBase)) {
    $apiBase = "http://localhost:4000"
}

# 创建文件内容
$lines = @(
    "# 高德地图 API Key（必需）",
    "# 获取方式：https://console.amap.com/dev/key/app",
    "# 选择Web端（JS API）类型的 Key",
    "NEXT_PUBLIC_AMAP_KEY=$amapKey",
    "",
    "# 后端 API 地址",
    "NEXT_PUBLIC_API_BASE=$apiBase",
    "",
    "# 可选：滚动联动阈值（毫秒）",
    "NEXT_PUBLIC_SCROLL_THROTTLE_MS=300",
    "NEXT_PUBLIC_SCROLL_SUPPRESS_MS=800"
)

# 写入文件
try {
    $lines | Out-File -FilePath $envFile -Encoding UTF8
    Write-Host ""
    Write-Host "配置成功！已创建 $envFile 文件" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步：" -ForegroundColor Cyan
    Write-Host "1. 重启开发服务器（如果正在运行）" -ForegroundColor White
    Write-Host "2. 访问 http://localhost:3000/admin/add-venue 测试地图" -ForegroundColor White
    Write-Host "3. 在 Vercel 中配置生产环境变量 NEXT_PUBLIC_AMAP_KEY" -ForegroundColor White
    Write-Host ""
} catch {
    Write-Host "创建文件失败：$_" -ForegroundColor Red
    exit 1
}
