@echo off
chcp 65001 >nul
echo ========================================
echo 高德地图 API Key 配置工具
echo ========================================
echo.

cd /d "%~dp0"

if exist .env.local (
    echo 发现已存在的 .env.local 文件
    set /p overwrite=是否覆盖？(y/N): 
    if /i not "%overwrite%"=="y" (
        echo 已取消操作
        pause
        exit /b
    )
)

echo.
echo 请输入你的高德地图 API Key：
echo （如果还没有，请访问：https://console.amap.com/dev/key/app）
set /p amapKey=NEXT_PUBLIC_AMAP_KEY: 

if "%amapKey%"=="" (
    echo API Key 不能为空！
    pause
    exit /b 1
)

echo.
echo 请输入后端 API 地址（默认：http://localhost:4000）：
set /p apiBase=NEXT_PUBLIC_API_BASE: 
if "%apiBase%"=="" set apiBase=http://localhost:4000

echo.
echo 正在创建 .env.local 文件...

(
echo # 高德地图 API Key（必需）
echo # 获取方式：https://console.amap.com/dev/key/app
echo # 选择Web端（JS API）类型的 Key
echo NEXT_PUBLIC_AMAP_KEY=%amapKey%
echo.
echo # 后端 API 地址
echo NEXT_PUBLIC_API_BASE=%apiBase%
echo.
echo # 可选：滚动联动阈值（毫秒）
echo NEXT_PUBLIC_SCROLL_THROTTLE_MS=300
echo NEXT_PUBLIC_SCROLL_SUPPRESS_MS=800
) > .env.local

if exist .env.local (
    echo.
    echo 配置成功！已创建 .env.local 文件
    echo.
    echo 下一步：
    echo 1. 重启开发服务器（如果正在运行）
    echo 2. 访问 http://localhost:3000/admin/add-venue 测试地图
    echo 3. 在 Vercel 中配置生产环境变量 NEXT_PUBLIC_AMAP_KEY
    echo.
) else (
    echo 创建文件失败！
    pause
    exit /b 1
)

pause




















