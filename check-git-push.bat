@echo off
chcp 65001 >nul
echo ========================================
echo Git 推送问题检查工具
echo ========================================
echo.

cd /d F:\Findyu

echo [1] 检查 Git 状态...
git status --short
echo.

echo [2] 检查当前分支...
git branch
echo.

echo [3] 检查远程仓库配置...
git remote -v
echo.

echo [4] 检查最近的提交...
git log --oneline -5
echo.

echo [5] 检查是否有未推送的提交...
git log origin/master..HEAD --oneline
if %errorlevel% equ 0 (
    echo 发现未推送的提交！
) else (
    echo 没有未推送的提交，或者远程分支不存在
)
echo.

echo [6] 尝试测试连接...
git ls-remote origin
echo.

echo ========================================
echo 检查完成！
echo ========================================
echo.
echo 如果看到错误，请检查：
echo 1. 网络连接是否正常
echo 2. GitHub 访问是否正常
echo 3. Git 凭据是否正确配置
echo.
pause





















