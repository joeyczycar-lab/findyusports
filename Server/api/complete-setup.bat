@echo off
chcp 65001 >nul
echo === 完成本地数据库配置 ===
echo.

echo 1. 检查数据库容器...
docker ps --filter "name=venues_pg"
echo.

echo 2. 等待数据库就绪...
timeout /t 5 /nobreak >nul

echo 3. 初始化 PostGIS 扩展...
docker exec venues_pg psql -U postgres -d venues -c "CREATE EXTENSION IF NOT EXISTS postgis;"
echo.

echo 4. 运行数据库迁移...
call npm run migration:run
echo.

echo 5. 检查数据库表...
docker exec venues_pg psql -U postgres -d venues -c "\dt"
echo.

echo === 配置完成 ===
echo.
echo 下一步：启动后端服务
echo   npm run dev
echo.

pause



