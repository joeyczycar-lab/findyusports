# 检查 Git 状态

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "检查 Git 状态" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot

Write-Host "📋 本地提交状态：" -ForegroundColor Yellow
git log --oneline -5

Write-Host ""
Write-Host "📦 未推送的提交：" -ForegroundColor Yellow
$localCommits = git log origin/master..HEAD --oneline 2>$null
if ($localCommits) {
    Write-Host $localCommits -ForegroundColor White
    Write-Host ""
    Write-Host "⚠️ 有未推送的提交" -ForegroundColor Yellow
} else {
    Write-Host "✅ 所有提交都已推送" -ForegroundColor Green
}

Write-Host ""
Write-Host "🔍 远程仓库信息：" -ForegroundColor Yellow
git remote -v

Write-Host ""
Write-Host "📝 工作区状态：" -ForegroundColor Yellow
git status --short
