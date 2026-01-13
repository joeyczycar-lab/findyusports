@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ========================================
echo 完成 Git 推送
echo ========================================
echo.

echo [1/2] 检查当前状态...
git status
echo.

echo [2/2] 推送到远程仓库...
git push origin master
if %errorlevel% neq 0 (
    echo.
    echo ⚠️ 推送失败，尝试使用 --force-with-lease...
    git push origin master --force-with-lease
    if %errorlevel% neq 0 (
        echo.
        echo ❌ 推送失败
        echo.
        echo 错误信息: Empty reply from server
        echo.
        echo 可能的原因:
        echo   1. 网络连接问题
        echo   2. GitHub 访问受限（在中国大陆很常见）
        echo   3. 代理配置问题
        echo.
        echo 解决方案:
        echo   1. 检查网络连接
        echo   2. 如果在中国大陆，配置代理或使用 VPN
        echo   3. 配置 Git 代理（如果有）:
        echo      git config --global http.proxy http://proxy.example.com:8080
        echo      git config --global https.proxy https://proxy.example.com:8080
        echo   4. 或切换到 SSH 方式:
        echo      git remote set-url origin git@github.com:joeyczycar-lab/findyusports.git
        echo      git push origin master
        echo   5. 稍后重试
        echo.
        pause
        exit /b 1
    )
)
echo ✅ 推送完成！
echo.

pause

