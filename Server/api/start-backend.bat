@echo off
chcp 65001 >nul
echo === 启动后端服务 ===
echo.

echo 检查数据库容器...
docker ps --filter "name=venues_pg"
if errorlevel 1 (
    echo [错误] 数据库容器未运行，正在启动...
    docker compose up -d
    timeout /t 5 /nobreak >nul
)

echo.
echo 启动后端服务...
echo 后端将运行在: http://localhost:4000
echo 按 Ctrl+C 停止服务
echo.

npm run dev



