@echo off
chcp 65001 >nul
echo === 测试后端 API ===
echo.

echo 1. 测试服务是否运行...
curl http://localhost:4000/venues
echo.
echo.

echo 2. 测试注册接口...
curl -X POST http://localhost:4000/auth/register ^
  -H "Content-Type: application/json" ^
  -d "{\"phone\":\"13800000001\",\"password\":\"123456\",\"nickname\":\"测试用户\"}"
echo.
echo.

echo === 测试完成 ===
pause



