@echo off
chcp 65001 >nul
echo ========================================
echo 检查并提交背景图片到 Git
echo ========================================
echo.

cd /d "%~dp0\..\.."

echo [1] 检查图片文件是否存在...
if exist "Web\webapp\public\hero-background.jpg" (
    echo ✓ 图片文件存在
) else (
    echo ✗ 图片文件不存在！
    pause
    exit /b 1
)

echo.
echo [2] 检查 Git 状态...
git status Web/webapp/public/hero-background.jpg

echo.
echo [3] 检查文件是否已跟踪...
git ls-files Web/webapp/public/hero-background.jpg >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ 文件已被 Git 跟踪
) else (
    echo ✗ 文件未被 Git 跟踪，需要添加
    echo.
    set /p add="是否添加到 Git？(y/N): "
    if /i "%add%"=="y" (
        git add Web/webapp/public/hero-background.jpg
        echo ✓ 已添加到 Git
    )
)

echo.
echo [4] 检查是否有未提交的更改...
git status --short Web/webapp/public/hero-background.jpg

echo.
echo ========================================
echo 下一步操作：
echo ========================================
echo.
echo 如果文件未提交，请运行：
echo   git add Web/webapp/public/hero-background.jpg
echo   git commit -m "添加主页背景图片"
echo   git push origin master
echo.
echo 然后 Vercel 会自动重新部署
echo.
pause



