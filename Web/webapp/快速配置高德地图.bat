@echo off
chcp 65001 >nul
cls
echo ========================================
echo 快速配置高德地图 API Key
echo ========================================
echo.
echo 请按照以下步骤操作：
echo.
echo 1. 访问：https://console.amap.com/dev/key/app
echo 2. 登录后创建应用，选择"Web端（JS API）"类型
echo 3. 复制生成的 Key
echo.
echo ========================================
echo.

cd /d "%~dp0"

echo 请输入你的高德地图 API Key：
set /p amapKey=Key: 

if "%amapKey%"=="" (
    echo.
    echo 错误：Key 不能为空！
    pause
    exit /b
)

echo.
echo 正在更新配置文件...

REM 创建新的配置文件内容
(
echo # 高德地图 API Key
echo NEXT_PUBLIC_AMAP_KEY=%amapKey%
echo.
echo # 后端 API 地址
echo NEXT_PUBLIC_API_BASE=http://localhost:4000
) > .env.local

if exist .env.local (
    echo.
    echo ========================================
    echo 配置成功！
    echo ========================================
    echo.
    echo 已更新 .env.local 文件
    echo.
    echo 下一步：
    echo 1. 重启开发服务器（如果正在运行）
    echo 2. 访问 http://localhost:3000/admin/add-venue 测试地图
    echo 3. 在 Vercel 中配置生产环境变量
    echo.
) else (
    echo.
    echo 错误：创建文件失败！
    echo.
)

pause




















