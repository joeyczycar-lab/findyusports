# 修复 TypeScript 错误并推送到 Git

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "修复并推送代码到 Git" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 切换到项目根目录
Set-Location $PSScriptRoot

# 检查 Git 状态
Write-Host "📋 检查 Git 状态..." -ForegroundColor Yellow
git status --short

Write-Host ""
Write-Host "📦 添加所有更改..." -ForegroundColor Yellow
git add .

Write-Host ""
Write-Host "💾 提交更改..." -ForegroundColor Yellow
$commitMessage = "修复: 解决 TypeScript 类型错误 (indoor/isPublic null 值处理)"
git commit -m $commitMessage

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 提交失败" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🚀 推送到远程仓库..." -ForegroundColor Yellow
git push

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ 代码已成功推送到 Git！" -ForegroundColor Green
    Write-Host "📝 Railway 将自动重新部署..." -ForegroundColor Green
    Write-Host ""
    Write-Host "💡 提示：等待 1-2 分钟后，Railway 会自动重新构建和部署" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "❌ 推送失败，请检查网络连接或 Git 配置" -ForegroundColor Red
    exit 1
}
