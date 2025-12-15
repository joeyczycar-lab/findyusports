Write-Host "正在启动前端开发服务器..." -ForegroundColor Green
Write-Host "前端将在 http://localhost:3000 启动" -ForegroundColor Green
Write-Host ""

$webDir = Join-Path $PSScriptRoot "..\Web\webapp"
Push-Location $webDir

try {
    npm run dev
} finally {
    Pop-Location
}









