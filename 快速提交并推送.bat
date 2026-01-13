@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ========================================
echo 快速提交并推送 Git
echo ========================================
echo.

echo [1/3] 检查状态...
git status --short
echo.

echo [2/3] 添加所有更改...
git add .
if %errorlevel% neq 0 (
    echo 错误: git add 失败
    pause
    exit /b 1
)
echo 成功
echo.

echo [3/3] 提交并推送...
set /p commitMsg=请输入提交信息（直接回车使用默认信息）: 
if "%commitMsg%"=="" (
    set commitMsg=Update: 代码更新
)

git commit -m "%commitMsg%"
if %errorlevel% neq 0 (
    echo 警告: 提交可能失败或没有更改
)

git push origin master
if %errorlevel% neq 0 (
    echo.
    echo 推送失败，请检查网络连接
    pause
    exit /b 1
)

echo.
echo ========================================
echo 完成！
echo ========================================
echo.

pause
