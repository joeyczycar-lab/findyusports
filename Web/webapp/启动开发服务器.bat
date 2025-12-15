@echo off
chcp 65001 >nul
echo ========================================
echo 启动 Next.js 开发服务器
echo ========================================
echo.

cd /d "%~dp0"

echo 正在启动开发服务器...
echo.
echo 服务器启动后，请访问：
echo   - 主页: http://localhost:3000
echo   - 测试页面: http://localhost:3000/test-bg
echo   - 图片测试: http://localhost:3000/test-image.html
echo.
echo 按 Ctrl+C 可以停止服务器
echo.
echo ========================================
echo.

npm run dev

pause



