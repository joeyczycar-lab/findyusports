@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ========================================
echo 跳过编辑器完成 Rebase
echo ========================================
echo.

echo 注意: 请先关闭 vim 编辑器窗口（如果还在打开）
echo 如果编辑器还在运行，请:
echo   1. 切换到编辑器窗口
echo   2. 按 Esc
echo   3. 输入 :q! 然后按 Enter
echo.
echo 按任意键继续...
pause >nul
echo.

echo [1/3] 配置 Git 使用非交互式编辑器...
set GIT_EDITOR=true
git config core.editor true
echo ✅ 已配置
echo.

echo [2/3] 继续 rebase...
git rebase --continue
if %errorlevel% neq 0 (
    echo.
    echo ⚠️ Rebase 可能已完成或还有问题
    echo 检查状态...
    git status
    echo.
    pause
    exit /b 1
)
echo ✅ Rebase 完成
echo.

echo [3/3] 推送到远程仓库...
git push origin master
if %errorlevel% neq 0 (
    echo.
    echo ⚠️ 推送失败，可能需要强制推送
    echo 尝试使用 --force-with-lease...
    git push origin master --force-with-lease
    if %errorlevel% neq 0 (
        echo.
        echo ❌ 推送仍然失败
        echo 可能的原因:
        echo   1. 网络连接问题（Empty reply from server）
        echo   2. GitHub 访问受限
        echo.
        echo 建议:
        echo   1. 检查网络连接
        echo   2. 如果在中国大陆，可能需要配置代理或使用 VPN
        echo   3. 稍后重试: git push origin master
        echo   4. 或使用 SSH: git remote set-url origin git@github.com:joeyczycar-lab/findyusports.git
        pause
        exit /b 1
    )
)
echo ✅ 推送完成！
echo.

pause

