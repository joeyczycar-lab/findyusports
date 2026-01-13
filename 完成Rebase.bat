@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ========================================
echo 完成 Rebase 操作
echo ========================================
echo.

echo 注意: 如果您正在 Git 编辑器中，请:
echo   1. 按 Esc 键（如果还没按）
echo   2. 输入 :wq 然后按 Enter（保存并退出）
echo   3. 或者输入 :q! 然后按 Enter（不保存退出，使用默认消息）
echo.
echo 如果编辑器已关闭，脚本将继续...
echo.

REM 检查是否还在 rebase 状态
git status | findstr "rebase" >nul 2>&1
if %errorlevel% equ 0 (
    echo 检测到仍在 rebase 状态，尝试继续...
    git rebase --continue
    if %errorlevel% neq 0 (
        echo.
        echo ⚠️ Rebase 可能还有问题
        echo 请检查状态: git status
        pause
        exit /b 1
    )
    echo ✅ Rebase 完成
) else (
    echo ✅ 不在 rebase 状态，可能已完成
)

echo.
echo [1/2] 检查当前状态...
git status
echo.

echo [2/2] 推送到远程仓库...
git push origin master
if %errorlevel% neq 0 (
    echo.
    echo ❌ Git push 失败
    echo 可能需要强制推送（如果远程历史已改变）:
    echo   git push origin master --force-with-lease
    echo.
    echo 或者先拉取:
    echo   git pull origin master --rebase
    pause
    exit /b 1
)
echo ✅ 推送完成！
echo.

pause

