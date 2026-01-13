@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ========================================
echo 解决冲突并完成推送
echo ========================================
echo.

echo [1/4] 添加已解决的冲突文件...
git add Server/api/src/modules/venues/venues.service.ts
git add Web/webapp/src/app/admin/add-venue/page.tsx
if %errorlevel% neq 0 (
    echo ❌ Git add 失败
    pause
    exit /b 1
)
echo ✅ 已添加冲突文件
echo.

echo [2/4] 继续 rebase...
git rebase --continue
if %errorlevel% neq 0 (
    echo.
    echo ⚠️ Rebase 可能还有冲突或已完成
    echo 检查状态...
    git status
    echo.
    echo 如果没有冲突，可以继续推送
    echo 如果有冲突，请手动解决后运行: git rebase --continue
    pause
    exit /b 1
)
echo ✅ Rebase 完成
echo.

echo [3/4] 检查当前状态...
git status
echo.

echo [4/4] 推送到远程仓库...
git push origin master
if %errorlevel% neq 0 (
    echo ❌ Git push 失败
    echo 可能的原因:
    echo   1. 网络连接问题
    echo   2. 需要先 pull 远程更改
    echo.
    echo 尝试强制推送（谨慎使用）:
    echo   git push origin master --force
    pause
    exit /b 1
)
echo ✅ 推送完成！
echo.

pause

