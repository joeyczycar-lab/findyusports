# 从 Railway 数据库同步数据到本地数据库
Write-Host "=== Railway 到本地数据库同步工具 ===" -ForegroundColor Cyan
Write-Host ""

# 检查环境变量
Write-Host "检查配置..." -ForegroundColor Yellow

$railwayUrl = $env:DATABASE_URL
if (-not $railwayUrl) {
    Write-Host "未找到 DATABASE_URL 环境变量" -ForegroundColor Yellow
    Write-Host "请提供 Railway 数据库连接字符串" -ForegroundColor White
    $railwayUrl = Read-Host "DATABASE_URL (格式: postgresql://user:password@host:port/database)"
}

if ([string]::IsNullOrWhiteSpace($railwayUrl)) {
    Write-Host "[错误] 必须提供 Railway 数据库连接字符串" -ForegroundColor Red
    exit 1
}

# 检查本地数据库容器
Write-Host ""
Write-Host "检查本地数据库..." -ForegroundColor Yellow
$container = docker ps --filter "name=venues_pg" --format "{{.Names}}" 2>&1
if ($container -notmatch "venues_pg") {
    Write-Host "[错误] 本地数据库容器未运行" -ForegroundColor Red
    Write-Host "请先启动: docker compose up -d" -ForegroundColor Yellow
    exit 1
}
Write-Host "[OK] 本地数据库容器正在运行" -ForegroundColor Green

# 生成临时备份文件名
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = "railway_backup_$timestamp.sql"

Write-Host ""
Write-Host "步骤 1: 从 Railway 导出数据..." -ForegroundColor Yellow
Write-Host "备份文件: $backupFile" -ForegroundColor Gray

# 从 Railway 导出数据
try {
    # 使用 pg_dump 导出数据
    $env:PGPASSWORD = ($railwayUrl -split '@')[0] -split ':' | Select-Object -Last 1 -Skip 1
    $railwayHost = ($railwayUrl -split '@')[1] -split '/' | Select-Object -First 1
    $railwayDb = ($railwayUrl -split '/') | Select-Object -Last 1
    $railwayUser = ($railwayUrl -split '://')[1] -split ':' | Select-Object -First 1
    
    # 构建 pg_dump 命令
    $dumpCmd = "pg_dump -h $railwayHost -U $railwayUser -d $railwayDb --data-only --table=venue --table=venue_image --table=review --table=app_user -f $backupFile"
    
    Write-Host "执行导出命令..." -ForegroundColor Gray
    # 注意：需要安装 PostgreSQL 客户端工具，或者使用 Docker 容器执行
    docker run --rm -v "${PWD}:/backup" postgres:15 pg_dump "$railwayUrl" --data-only --table=venue --table=venue_image --table=review --table=app_user -f "/backup/$backupFile" 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] 数据导出成功" -ForegroundColor Green
    } else {
        Write-Host "[错误] 数据导出失败" -ForegroundColor Red
        Write-Host "提示: 可能需要安装 PostgreSQL 客户端工具" -ForegroundColor Yellow
        Write-Host "或者手动从 Railway 导出数据" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "[错误] 导出过程出错: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "替代方案: 手动导出" -ForegroundColor Yellow
    Write-Host "1. 在 Railway 控制台使用 Query 功能导出数据" -ForegroundColor White
    Write-Host "2. 或使用 pgAdmin 等工具连接 Railway 数据库导出" -ForegroundColor White
    exit 1
}

Write-Host ""
Write-Host "步骤 2: 导入数据到本地数据库..." -ForegroundColor Yellow

# 导入到本地数据库
try {
    Write-Host "正在导入数据..." -ForegroundColor Gray
    Get-Content $backupFile | docker exec -i venues_pg psql -U postgres -d venues 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] 数据导入成功" -ForegroundColor Green
    } else {
        Write-Host "[警告] 导入过程可能有错误，请检查" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[错误] 导入过程出错: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "步骤 3: 验证数据..." -ForegroundColor Yellow

# 检查数据条数
$venueCount = docker exec venues_pg psql -U postgres -d venues -t -c "SELECT COUNT(*) FROM venue;" 2>&1
$userCount = docker exec venues_pg psql -U postgres -d venues -t -c "SELECT COUNT(*) FROM app_user;" 2>&1

Write-Host "场地数量: $venueCount" -ForegroundColor Cyan
Write-Host "用户数量: $userCount" -ForegroundColor Cyan

Write-Host ""
Write-Host "=== 同步完成 ===" -ForegroundColor Green
Write-Host ""
Write-Host "备份文件已保存: $backupFile" -ForegroundColor Gray
Write-Host "可以删除备份文件以节省空间" -ForegroundColor Gray
Write-Host ""



