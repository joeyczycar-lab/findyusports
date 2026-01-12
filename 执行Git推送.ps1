# 执行 Git 推送脚本
# 自动处理 detached HEAD 问题

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "执行 Git 推送" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 切换到脚本所在目录
Set-Location $PSScriptRoot

Write-Host "[0/4] 检查当前分支状态..." -ForegroundColor Yellow
try {
    $status = git status --short 2>&1
} catch {
    Write-Host "警告: 可能不在 Git 仓库中" -ForegroundColor Yellow
}

# 检查是否在 detached HEAD 状态
$ref = git symbolic-ref -q HEAD 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "检测到 detached HEAD 状态，正在切换到主分支..." -ForegroundColor Yellow
    
    # 尝试切换到 main 分支
    git checkout main 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        # 如果 main 不存在，尝试 master
        git checkout master 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ 无法找到主分支，请手动切换到正确的分支" -ForegroundColor Red
            Write-Host "可用的分支:" -ForegroundColor Yellow
            git branch -a
            Read-Host "按 Enter 键退出"
            exit 1
        }
    }
    Write-Host "✅ 已切换到主分支" -ForegroundColor Green
} else {
    Write-Host "✅ 当前在正常分支上" -ForegroundColor Green
}
Write-Host ""

Write-Host "[1/4] 添加所有更改..." -ForegroundColor Yellow
git add .
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Git add 失败" -ForegroundColor Red
    Read-Host "按 Enter 键退出"
    exit 1
}
Write-Host "✅ 已添加所有更改" -ForegroundColor Green
Write-Host ""

Write-Host "[2/4] 提交更改..." -ForegroundColor Yellow
git commit -m "修复 geom 列问题、优化启动脚本和认证功能、添加 PowerShell 脚本"
if ($LASTEXITCODE -ne 0) {
    Write-Host "注意: 可能没有需要提交的更改，或提交失败" -ForegroundColor Yellow
    # 继续执行，可能只是没有更改
}
Write-Host "✅ 提交步骤完成" -ForegroundColor Green
Write-Host ""

Write-Host "[3/4] 获取当前分支名称..." -ForegroundColor Yellow
$currentBranch = git rev-parse --abbrev-ref HEAD
Write-Host "当前分支: $currentBranch" -ForegroundColor Cyan
Write-Host ""

Write-Host "[4/4] 推送到远程仓库..." -ForegroundColor Yellow
git push origin $currentBranch
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Git push 失败，尝试使用默认推送方式..." -ForegroundColor Yellow
    git push
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Git push 仍然失败" -ForegroundColor Red
        Write-Host "请检查:" -ForegroundColor Yellow
        Write-Host "  1. 网络连接" -ForegroundColor Yellow
        Write-Host "  2. Git 远程仓库配置 (git remote -v)" -ForegroundColor Yellow
        Write-Host "  3. 是否有推送权限" -ForegroundColor Yellow
        Read-Host "按 Enter 键退出"
        exit 1
    }
}
Write-Host "✅ 推送完成！" -ForegroundColor Green
Write-Host ""

Read-Host "按 Enter 键退出"
