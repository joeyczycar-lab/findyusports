@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ========================================
echo 同步远程更改并推送
echo ========================================
echo.

echo [1/5] 检查当前状态...
git status
echo.

echo [2/5] 获取远程更改（不合并）...
git fetch origin
if %errorlevel% neq 0 (
    echo ❌ Git fetch 失败
    echo 可能的原因:
    echo   1. 网络连接问题
    echo   2. GitHub 访问受限（可能需要代理）
    echo   3. 远程仓库地址错误
    echo.
    echo 请检查网络连接后重试，或配置 Git 代理:
    echo   git config --global http.proxy http://proxy.example.com:8080
    echo   git config --global https.proxy https://proxy.example.com:8080
    pause
    exit /b 1
)
echo ✅ 已获取远程更改
echo.

echo [3/5] 使用 rebase 方式整合远程更改...
echo 注意: 如果本地有未提交的更改，可能会提示冲突
git pull --rebase origin master
if %errorlevel% neq 0 (
    echo.
    echo ⚠️ Pull 失败，可能的原因:
    echo   1. 有冲突需要解决
    echo   2. 网络问题
    echo.
    echo 如果是因为冲突，请:
    echo   1. 解决冲突文件
    echo   2. 运行: git add .
    echo   3. 运行: git rebase --continue
    echo   4. 然后重新运行此脚本
    echo.
    echo 如果想放弃本地更改，使用远程版本:
    echo   git reset --hard origin/master
    pause
    exit /b 1
)
echo ✅ 已整合远程更改
echo.

echo [4/5] 检查是否有需要推送的更改...
git log origin/master..HEAD --oneline >nul 2>&1
if %errorlevel% equ 0 (
    echo 发现本地有新提交，准备推送...
) else (
    echo 没有需要推送的更改
    goto :skip_push
)
echo.

echo [5/5] 推送到远程仓库...
git push origin master
if %errorlevel% neq 0 (
    echo.
    echo ❌ Git push 失败
    echo 可能的原因:
    echo   1. 网络连接问题（Empty reply from server）
    echo   2. GitHub 访问受限
    echo   3. 权限问题
    echo.
    echo 建议:
    echo   1. 检查网络连接
    echo   2. 如果在中国大陆，可能需要配置代理或使用 VPN
    echo   3. 稍后重试: git push origin master
    echo   4. 或使用 SSH 方式: git remote set-url origin git@github.com:joeyczycar-lab/findyusports.git
    pause
    exit /b 1
)
echo ✅ 推送完成！
echo.

:skip_push
echo ========================================
echo 操作完成！
echo ========================================
pause

