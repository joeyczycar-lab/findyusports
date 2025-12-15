@echo off
cd /d "%~dp0"
(
echo # 高德地图 API Key
echo NEXT_PUBLIC_AMAP_KEY=92a0f4147614a72916eebb75f26784cd
echo.
echo # 后端 API 地址
echo NEXT_PUBLIC_API_BASE=http://localhost:4000
echo.
echo # 可选：滚动联动阈值（毫秒）
echo NEXT_PUBLIC_SCROLL_THROTTLE_MS=300
echo NEXT_PUBLIC_SCROLL_SUPPRESS_MS=800
) > .env.local
echo 配置文件已创建！
echo.
echo 当前配置：
type .env.local
echo.
pause



