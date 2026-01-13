@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ========================================
echo 修复 Rebase 状态并推送
echo ========================================
echo.

echo [1/5] 中止当前的 rebase 操作...
git rebase --abort
if %errorlevel% neq 0 (
    echo 警告: rebase --abort 可能失败，继续尝试...
)
echo ✅ Rebase 已中止
echo.

echo [2/5] 切换到 master 分支...
git checkout master
if %errorlevel% neq 0 (
    echo ❌ 无法切换到 master 分支
    echo 当前状态:
    git status
    pause
    exit /b 1
)
echo ✅ 已切换到 master 分支
echo.

echo [3/5] 添加所有更改...
git add .
if %errorlevel% neq 0 (
    echo ❌ Git add 失败
    pause
    exit /b 1
)
echo ✅ 已添加所有更改
echo.

echo [4/5] 提交更改...
git commit -m "修复 geom 列问题、优化启动脚本和认证功能、添加 PowerShell 脚本"
if %errorlevel% neq 0 (
    echo 注意: 可能没有需要提交的更改
)
echo ✅ 提交步骤完成
echo.

echo [5/5] 推送到远程仓库...
git push origin master
if %errorlevel% neq 0 (
    echo ❌ Git push 失败，尝试默认推送...
    git push
    if %errorlevel% neq 0 (
        echo ❌ Git push 仍然失败
        echo 请检查网络连接和 Git 配置
        pause
        exit /b 1
    )
)
echo ✅ 推送完成！
echo.

pause

