@echo off
chcp 65001 >nul
echo ========================================
echo 更新高德地图 API Key
echo ========================================
echo.

cd /d "%~dp0"

if not exist .env.local (
    echo 错误: 找不到 .env.local 文件
    echo 请先运行 setup-amap-simple.bat 创建配置文件
    pause
    exit /b 1
)

echo.
echo 请输入你的高德地图 API Key：
set /p amapKey=NEXT_PUBLIC_AMAP_KEY: 

if "%amapKey%"=="" (
    echo 错误: API Key 不能为空！
    pause
    exit /b 1
)

echo.
echo 正在更新 .env.local 文件...

REM 使用 PowerShell 来更新文件（更可靠）
powershell -Command "$content = Get-Content .env.local -Raw -Encoding UTF8; $content = $content -replace 'NEXT_PUBLIC_AMAP_KEY=.*', 'NEXT_PUBLIC_AMAP_KEY=%amapKey%'; $content = $content -replace 'NEXT_PUBLIC_API_BASE=.*\r?\n', ''; $apiBase = 'http://localhost:4000'; if ($content -match 'NEXT_PUBLIC_API_BASE=([^\r\n]+)') { $apiBase = $matches[1] }; $content = $content.Trim() + \"`r`n`r`nNEXT_PUBLIC_API_BASE=$apiBase`r`n\"; [System.IO.File]::WriteAllText((Resolve-Path .).Path + '\\.env.local', $content.Trim(), [System.Text.Encoding]::UTF8)"

if %errorlevel% equ 0 (
    echo.
    echo 成功！已更新 .env.local 文件
    echo.
    echo 下一步：
    echo 1. 重启开发服务器（如果正在运行）
    echo 2. 访问 http://localhost:3000/admin/add-venue 测试地图
    echo.
) else (
    echo.
    echo 更新失败！请手动编辑 .env.local 文件
    echo 添加或修改这一行：
    echo NEXT_PUBLIC_AMAP_KEY=%amapKey%
    echo.
)

pause



