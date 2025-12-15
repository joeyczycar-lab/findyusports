# OSS 配置检查脚本
Write-Host "=== OSS 配置检查 ===" -ForegroundColor Cyan
Write-Host ""

$envFile = ".env"
if (-not (Test-Path $envFile)) {
    Write-Host "❌ .env 文件不存在！" -ForegroundColor Red
    exit 1
}

Write-Host "✅ .env 文件存在" -ForegroundColor Green
Write-Host ""

# 检查 OSS 配置
$content = Get-Content $envFile
$allPassed = $true

# 检查每个配置项
$configs = @("OSS_REGION", "OSS_ACCESS_KEY_ID", "OSS_ACCESS_KEY_SECRET", "OSS_BUCKET")

foreach ($configName in $configs) {
    $found = $false
    $commented = $false
    $hasValue = $false
    
    foreach ($line in $content) {
        if ($line -match "$configName\s*=") {
            $found = $true
            if ($line.Trim().StartsWith('#')) {
                $commented = $true
                Write-Host "❌ $configName : 已被注释（需要取消注释）" -ForegroundColor Yellow
                $allPassed = $false
            } else {
                $value = ($line -split '=', 2)[1].Trim()
                if ([string]::IsNullOrWhiteSpace($value) -or $value -match 'your_|placeholder') {
                    Write-Host "⚠️  $configName : 已配置但值为空或占位符" -ForegroundColor Yellow
                    Write-Host "   当前值: $value" -ForegroundColor Gray
                    $allPassed = $false
                } else {
                    if ($configName -match "SECRET|KEY") {
                        $displayValue = if ($value.Length -gt 8) { $value.Substring(0, 8) + "***" } else { "***" }
                    } else {
                        $displayValue = $value
                    }
                    Write-Host "✅ $configName : 已正确配置" -ForegroundColor Green
                    Write-Host "   值: $displayValue" -ForegroundColor Gray
                    $hasValue = $true
                }
            }
            break
        }
    }
    
    if (-not $found) {
        Write-Host "❌ $configName : 未找到（需要添加）" -ForegroundColor Red
        $allPassed = $false
    }
}

Write-Host ""
Write-Host "=== 检查结果 ===" -ForegroundColor Cyan

if ($allPassed) {
    Write-Host "✅ 所有必需的 OSS 配置项都已正确配置！" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步：" -ForegroundColor Yellow
    Write-Host "1. 重启后端服务: npm run dev" -ForegroundColor White
    Write-Host "2. 测试图片上传功能" -ForegroundColor White
} else {
    Write-Host "❌ 配置不完整，请按照以下步骤修复：" -ForegroundColor Red
    Write-Host ""
    Write-Host "修复步骤：" -ForegroundColor Yellow
    Write-Host "1. 打开 .env 文件" -ForegroundColor White
    Write-Host "2. 找到 OSS 配置部分（以 # 阿里云OSS配置 开头）" -ForegroundColor White
    Write-Host "3. 取消注释（删除行首的 # 号）" -ForegroundColor White
    Write-Host "4. 填入真实的配置值：" -ForegroundColor White
    Write-Host "   - OSS_REGION=oss-cn-hangzhou" -ForegroundColor Gray
    Write-Host "   - OSS_ACCESS_KEY_ID=你的AccessKey_ID" -ForegroundColor Gray
    Write-Host "   - OSS_ACCESS_KEY_SECRET=你的AccessKey_Secret" -ForegroundColor Gray
    Write-Host "   - OSS_BUCKET=venues-images" -ForegroundColor Gray
    Write-Host ""
    Write-Host "详细配置说明请查看: OSS_CONFIG_GUIDE.md" -ForegroundColor Cyan
}
