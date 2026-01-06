# 检查数据库类型：Docker 还是 Railway
Write-Host "=== 检查数据库类型 ===" -ForegroundColor Cyan
Write-Host ""

# 1. 检查本地 Docker 容器
Write-Host "1. 检查本地 Docker 容器..." -ForegroundColor Yellow
try {
    $dockerContainers = docker ps -a --filter "name=venues_pg" --format "{{.Names}} - {{.Status}}" 2>&1
    if ($LASTEXITCODE -eq 0 -and $dockerContainers) {
        Write-Host "   ✅ 找到 Docker 容器: $dockerContainers" -ForegroundColor Green
        Write-Host "   → 你使用的是本地 Docker" -ForegroundColor Cyan
    } else {
        Write-Host "   ❌ 未找到 Docker 容器" -ForegroundColor Red
    }
} catch {
    Write-Host "   ⚠️  Docker 命令不可用（可能未安装）" -ForegroundColor Yellow
}

Write-Host ""

# 2. 检查前端 API 地址
Write-Host "2. 检查前端 API 地址配置..." -ForegroundColor Yellow
$envFile = "..\Web\webapp\.env.local"
if (Test-Path $envFile) {
    $content = Get-Content $envFile
    $apiBase = $content | Where-Object { $_ -match "NEXT_PUBLIC_API_BASE" }
    if ($apiBase) {
        Write-Host "   $apiBase" -ForegroundColor Cyan
        if ($apiBase -match "railway|up\.railway\.app") {
            Write-Host "   → 前端指向 Railway 后端" -ForegroundColor Green
        } elseif ($apiBase -match "localhost|127\.0\.0\.1") {
            Write-Host "   → 前端指向本地后端（可能用 Docker）" -ForegroundColor Green
        }
    } else {
        Write-Host "   ⚠️  未找到 NEXT_PUBLIC_API_BASE 配置" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ⚠️  未找到 .env.local 文件" -ForegroundColor Yellow
}

Write-Host ""

# 3. 检查 Railway 配置
Write-Host "3. 检查 Railway 配置..." -ForegroundColor Yellow
if (Test-Path "..\railway.json") {
    Write-Host "   ✅ 找到 railway.json 配置文件" -ForegroundColor Green
    Write-Host "   → 项目可能已部署到 Railway" -ForegroundColor Cyan
} else {
    Write-Host "   ❌ 未找到 railway.json" -ForegroundColor Red
}

Write-Host ""

# 4. 检查后端环境变量
Write-Host "4. 检查后端环境变量..." -ForegroundColor Yellow
$apiEnvFile = "api\.env"
if (Test-Path $apiEnvFile) {
    $content = Get-Content $apiEnvFile
    $dbUrl = $content | Where-Object { $_ -match "DATABASE_URL" }
    $dbHost = $content | Where-Object { $_ -match "DB_HOST" }
    
    if ($dbUrl) {
        Write-Host "   ✅ 找到 DATABASE_URL（Railway 常用）" -ForegroundColor Green
        Write-Host "   → 可能使用 Railway 数据库" -ForegroundColor Cyan
    } elseif ($dbHost) {
        Write-Host "   ✅ 找到 DB_HOST（本地 Docker 常用）" -ForegroundColor Green
        Write-Host "   → 可能使用本地 Docker" -ForegroundColor Cyan
    } else {
        Write-Host "   ⚠️  未找到数据库配置" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ⚠️  未找到 .env 文件" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== 判断结果 ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 请根据以上信息判断：" -ForegroundColor Yellow
Write-Host "   1. 如果找到 Docker 容器 → 使用本地 Docker" -ForegroundColor White
Write-Host "   2. 如果前端指向 railway.app → 使用 Railway" -ForegroundColor White
Write-Host "   3. 如果找到 railway.json → 可能已部署到 Railway" -ForegroundColor White
Write-Host ""
Write-Host "💡 建议：" -ForegroundColor Yellow
Write-Host "   - 如果使用 Railway：登录 https://railway.app 下载数据库备份" -ForegroundColor White
Write-Host "   - 如果使用 Docker：重新安装 Docker Desktop 后备份" -ForegroundColor White











