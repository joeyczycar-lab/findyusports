# 重试 Git 推送脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "重试 Git 推送" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot

# 检查 Git 状态
Write-Host "📋 检查 Git 状态..." -ForegroundColor Yellow
git status --short

Write-Host ""
Write-Host "🔍 检查远程仓库连接..." -ForegroundColor Yellow
git remote -v

Write-Host ""
Write-Host "🚀 尝试推送到远程仓库..." -ForegroundColor Yellow

$maxRetries = 3
$retryCount = 0
$success = $false

while ($retryCount -lt $maxRetries -and -not $success) {
    $retryCount++
    Write-Host ""
    Write-Host "尝试 $retryCount/$maxRetries..." -ForegroundColor Cyan
    
    try {
        git push
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ 推送成功！" -ForegroundColor Green
            $success = $true
        } else {
            Write-Host "❌ 推送失败 (退出代码: $LASTEXITCODE)" -ForegroundColor Red
            if ($retryCount -lt $maxRetries) {
                Write-Host "等待 5 秒后重试..." -ForegroundColor Yellow
                Start-Sleep -Seconds 5
            }
        }
    } catch {
        Write-Host "❌ 推送失败: $_" -ForegroundColor Red
        if ($retryCount -lt $maxRetries) {
            Write-Host "等待 5 秒后重试..." -ForegroundColor Yellow
            Start-Sleep -Seconds 5
        }
    }
}

if (-not $success) {
    Write-Host ""
    Write-Host "❌ 多次尝试后仍然失败" -ForegroundColor Red
    Write-Host ""
    Write-Host "可能的原因：" -ForegroundColor Yellow
    Write-Host "1. 网络连接问题" -ForegroundColor White
    Write-Host "2. GitHub 服务器暂时不可用" -ForegroundColor White
    Write-Host "3. 代理或防火墙阻止连接" -ForegroundColor White
    Write-Host ""
    Write-Host "建议：" -ForegroundColor Yellow
    Write-Host "1. 检查网络连接" -ForegroundColor White
    Write-Host "2. 稍后重试（等待几分钟）" -ForegroundColor White
    Write-Host "3. 检查代理设置（如果有）" -ForegroundColor White
    Write-Host ""
    Write-Host "💡 提示：代码已提交到本地，不会丢失。可以稍后再次尝试推送。" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "📝 Railway 将自动检测到代码更新并重新部署..." -ForegroundColor Green
    Write-Host "💡 等待 1-2 分钟后，检查 Railway 的部署状态" -ForegroundColor Cyan
}
