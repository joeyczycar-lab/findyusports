@echo off
chcp 65001 >nul
echo === 数据库备份工具 ===
echo.

REM 检查 Docker 是否运行
docker ps >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker 未运行，请先启动 Docker Desktop
    pause
    exit /b 1
)

REM 检查并启动数据库容器
docker ps -a --filter "name=venues_pg" --format "{{.Names}}" | findstr venues_pg >nul
if errorlevel 1 (
    echo ⚠️  数据库容器不存在，正在启动...
    cd api
    docker compose up -d
    timeout /t 5 /nobreak >nul
    cd ..
)

docker ps --filter "name=venues_pg" --format "{{.Names}}" | findstr venues_pg >nul
if errorlevel 1 (
    echo ⚠️  数据库容器未运行，正在启动...
    cd api
    docker compose start db
    timeout /t 5 /nobreak >nul
    cd ..
)

REM 生成备份文件名（带时间戳）
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set timestamp=%datetime:~0,8%_%datetime:~8,6%
set backupFile=backup_venues_%timestamp%.sql
set backupPath=%~dp0%backupFile%

echo 📦 正在备份数据库...
echo    容器: venues_pg
echo    数据库: venues
echo    备份文件: %backupFile%
echo.

REM 执行备份
docker exec venues_pg pg_dump -U postgres venues > "%backupPath%" 2>&1

if exist "%backupPath%" (
    for %%A in ("%backupPath%") do set size=%%~zA
    set /a sizeKB=%size% / 1024
    echo ✅ 备份成功！
    echo    文件位置: %backupPath%
    echo    文件大小: %sizeKB% KB
    echo.
    echo 📋 下一步操作：
    echo    1. 将备份文件复制到 Mac（U盘/网盘/微信文件传输助手）
    echo    2. 在 Mac 上恢复数据库：
    echo       cd ~/Desktop/findyusports/Server/api
    echo       docker compose up -d
    echo       docker exec -i venues_pg psql -U postgres venues ^< %backupFile%
) else (
    echo ❌ 备份失败！
    echo    请检查数据库容器是否正常运行
    echo    运行以下命令检查：
    echo    docker ps -a ^| findstr venues_pg
)

echo.
pause












