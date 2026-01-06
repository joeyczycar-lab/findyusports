# 简化版：从 Railway 同步数据到本地（使用 SQL 导出）
Write-Host "=== Railway 数据同步工具（简化版）===" -ForegroundColor Cyan
Write-Host ""

Write-Host "这个工具会帮助你从 Railway 数据库同步数据到本地数据库" -ForegroundColor Yellow
Write-Host ""

# 方法 1: 使用 Railway 的 Query 功能导出
Write-Host "方法 1: 使用 Railway Query 导出（推荐）" -ForegroundColor Green
Write-Host ""
Write-Host "步骤：" -ForegroundColor Yellow
Write-Host "1. 登录 Railway: https://railway.app" -ForegroundColor White
Write-Host "2. 进入你的数据库服务" -ForegroundColor White
Write-Host "3. 点击 'Query' 标签页" -ForegroundColor White
Write-Host "4. 执行以下 SQL 查询导出场地数据：" -ForegroundColor White
Write-Host ""
Write-Host "   SELECT * FROM venue;" -ForegroundColor Gray
Write-Host ""
Write-Host "5. 点击 'Download' 或 'Export' 下载 CSV 文件" -ForegroundColor White
Write-Host "6. 对以下表重复步骤 4-5：" -ForegroundColor White
Write-Host "   - venue_image" -ForegroundColor Gray
Write-Host "   - review" -ForegroundColor Gray
Write-Host "   - app_user" -ForegroundColor Gray
Write-Host ""

# 方法 2: 使用 pg_dump（需要 PostgreSQL 客户端）
Write-Host "方法 2: 使用 pg_dump 导出" -ForegroundColor Green
Write-Host ""
Write-Host "如果你安装了 PostgreSQL 客户端工具：" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. 从 Railway 获取 DATABASE_URL" -ForegroundColor White
Write-Host "2. 运行导出命令：" -ForegroundColor White
Write-Host ""
Write-Host '   pg_dump "你的DATABASE_URL" --data-only --table=venue --table=venue_image --table=review --table=app_user > railway_data.sql' -ForegroundColor Gray
Write-Host ""
Write-Host "3. 导入到本地数据库：" -ForegroundColor White
Write-Host ""
Write-Host '   docker exec -i venues_pg psql -U postgres -d venues < railway_data.sql' -ForegroundColor Gray
Write-Host ""

# 方法 3: 使用 Docker 容器执行 pg_dump
Write-Host "方法 3: 使用 Docker 容器导出（无需安装 PostgreSQL）" -ForegroundColor Green
Write-Host ""
Write-Host "步骤：" -ForegroundColor Yellow
Write-Host "1. 从 Railway 获取 DATABASE_URL" -ForegroundColor White
Write-Host "2. 运行以下命令：" -ForegroundColor White
Write-Host ""
Write-Host '   docker run --rm -v "${PWD}:/backup" postgres:15 pg_dump "你的DATABASE_URL" --data-only --table=venue --table=venue_image --table=review --table=app_user -f /backup/railway_data.sql' -ForegroundColor Gray
Write-Host ""
Write-Host "3. 导入到本地数据库：" -ForegroundColor White
Write-Host ""
Write-Host '   docker exec -i venues_pg psql -U postgres -d venues < railway_data.sql' -ForegroundColor Gray
Write-Host ""

Write-Host "=== 快速同步脚本 ===" -ForegroundColor Cyan
Write-Host ""
$useScript = Read-Host "是否使用自动同步脚本？(y/n)"

if ($useScript -eq "y") {
    Write-Host ""
    Write-Host "请输入 Railway DATABASE_URL：" -ForegroundColor Yellow
    $railwayUrl = Read-Host "DATABASE_URL"
    
    if ([string]::IsNullOrWhiteSpace($railwayUrl)) {
        Write-Host "[错误] DATABASE_URL 不能为空" -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
    Write-Host "正在导出数据..." -ForegroundColor Yellow
    
    # 使用 Docker 容器导出
    $backupFile = "railway_data_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql"
    docker run --rm -v "${PWD}:/backup" postgres:15 pg_dump "$railwayUrl" --data-only --table=venue --table=venue_image --table=review --table=app_user -f "/backup/$backupFile" 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] 数据导出成功: $backupFile" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "正在导入到本地数据库..." -ForegroundColor Yellow
        Get-Content $backupFile | docker exec -i venues_pg psql -U postgres -d venues 2>&1 | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] 数据导入成功" -ForegroundColor Green
            
            # 验证
            Write-Host ""
            Write-Host "验证数据..." -ForegroundColor Yellow
            $venueCount = docker exec venues_pg psql -U postgres -d venues -t -c "SELECT COUNT(*) FROM venue;" 2>&1
            Write-Host "场地数量: $venueCount" -ForegroundColor Cyan
        } else {
            Write-Host "[警告] 导入可能有问题，请检查备份文件" -ForegroundColor Yellow
        }
    } else {
        Write-Host "[错误] 导出失败，请检查 DATABASE_URL 是否正确" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== 完成 ===" -ForegroundColor Green
Write-Host ""



