@echo off
echo 正在设置数据库...
echo.

REM 尝试找到 PostgreSQL 18 的 psql 路径
set PG_PATH=C:\Program Files\PostgreSQL\18\bin
if not exist "%PG_PATH%\psql.exe" (
    echo 错误: 未找到 PostgreSQL 18 安装路径
    echo 请手动设置 PG_PATH 变量
    pause
    exit /b 1
)

echo 使用 PostgreSQL 路径: %PG_PATH%
echo.

REM 设置密码环境变量
set PGPASSWORD=324714

echo 正在创建数据库 venues...
"%PG_PATH%\psql.exe" -U postgres -h localhost -c "SELECT 'CREATE DATABASE venues' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'venues')\gexec" 2>nul

echo 正在启用 PostGIS 扩展...
"%PG_PATH%\psql.exe" -U postgres -h localhost -d venues -c "CREATE EXTENSION IF NOT EXISTS postgis;"

echo 正在验证 PostGIS...
"%PG_PATH%\psql.exe" -U postgres -h localhost -d venues -c "SELECT PostGIS_version();"

echo.
echo 数据库设置完成！
pause


