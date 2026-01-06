# 备份阿里云 RDS PostgreSQL 数据库
Write-Host "=== 阿里云数据库备份工具 ===" -ForegroundColor Cyan
Write-Host ""

# 检查是否安装了 PostgreSQL 客户端工具
Write-Host "检查 PostgreSQL 客户端工具..." -ForegroundColor Yellow
$pgDumpPath = $null

# 检查常见路径
$possiblePaths = @(
    "C:\Program Files\PostgreSQL\*\bin\pg_dump.exe",
    "C:\Program Files (x86)\PostgreSQL\*\bin\pg_dump.exe",
    "$env:ProgramFiles\PostgreSQL\*\bin\pg_dump.exe",
    "$env:ProgramFiles(x86)\PostgreSQL\*\bin\pg_dump.exe"
)

foreach ($path in $possiblePaths) {
    $found = Get-ChildItem -Path $path -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        $pgDumpPath = $found.FullName
        break
    }
}

# 检查环境变量 PATH 中是否有 pg_dump
if (-not $pgDumpPath) {
    try {
        $null = Get-Command pg_dump -ErrorAction Stop
        $pgDumpPath = "pg_dump"
    } catch {
        # 继续查找
    }
}

if ($pgDumpPath) {
    Write-Host "✅ 找到 pg_dump: $pgDumpPath" -ForegroundColor Green
} else {
    Write-Host "❌ 未找到 pg_dump 工具" -ForegroundColor Red
    Write-Host ""
    Write-Host "需要安装 PostgreSQL 客户端工具：" -ForegroundColor Yellow
    Write-Host "   1. 下载：https://www.postgresql.org/download/windows/" -ForegroundColor Cyan
    Write-Host "   2. 安装时选择 'Command Line Tools'" -ForegroundColor White
    Write-Host "   3. 或者使用 Docker 方式备份（见下方）" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host ""

# 尝试从环境变量读取数据库连接信息
Write-Host "检查数据库连接信息..." -ForegroundColor Yellow

$dbHost = $null
$dbPort = $null
$dbUser = $null
$dbPass = $null
$dbName = $null
$dbUrl = $null

# 检查后端 .env 文件
$envFile = "api\.env"
if (Test-Path $envFile) {
    $envContent = Get-Content $envFile
    foreach ($line in $envContent) {
        if ($line -match "^DB_HOST=(.+)$") {
            $dbHost = $matches[1].Trim()
        }
        if ($line -match "^DB_PORT=(.+)$") {
            $dbPort = $matches[1].Trim()
        }
        if ($line -match "^DB_USER=(.+)$") {
            $dbUser = $matches[1].Trim()
        }
        if ($line -match "^DB_PASS=(.+)$") {
            $dbPass = $matches[1].Trim()
        }
        if ($line -match "^DB_NAME=(.+)$") {
            $dbName = $matches[1].Trim()
        }
        if ($line -match "^DATABASE_URL=(.+)$") {
            $dbUrl = $matches[1].Trim()
        }
    }
}

# 如果找到 DATABASE_URL，解析它
if ($dbUrl -and -not $dbHost) {
    if ($dbUrl -match "postgresql://([^:]+):([^@]+)@([^:]+):(\d+)/(.+)") {
        $dbUser = $matches[1]
        $dbPass = $matches[2]
        $dbHost = $matches[3]
        $dbPort = $matches[4]
        $dbName = $matches[5]
    }
}

# 显示找到的信息
if ($dbHost -and $dbHost -ne "localhost" -and $dbHost -ne "127.0.0.1") {
    Write-Host "✅ 找到数据库配置：" -ForegroundColor Green
    Write-Host "   主机: $dbHost" -ForegroundColor Cyan
    Write-Host "   端口: $dbPort" -ForegroundColor Cyan
    Write-Host "   用户: $dbUser" -ForegroundColor Cyan
    Write-Host "   数据库: $dbName" -ForegroundColor Cyan
    Write-Host ""
    
    # 提示用户确认
    Write-Host "是否使用以上配置进行备份？" -ForegroundColor Yellow
    Write-Host "   如果主机是阿里云 RDS，请输入 Y" -ForegroundColor White
    Write-Host "   如果需要手动输入连接信息，请输入 N" -ForegroundColor White
    $confirm = Read-Host "   (Y/N)"
    
    if ($confirm -ne "Y" -and $confirm -ne "y") {
        Write-Host ""
        Write-Host "请手动输入数据库连接信息：" -ForegroundColor Yellow
        $dbHost = Read-Host "   数据库主机地址（例如：rm-xxxxx.pg.rds.aliyuncs.com）"
        $dbPort = Read-Host "   端口（默认 5432）"
        if (-not $dbPort) { $dbPort = "5432" }
        $dbUser = Read-Host "   用户名"
        $dbPass = Read-Host "   密码" -AsSecureString
        $dbPassPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPass))
        $dbName = Read-Host "   数据库名"
    } else {
        # 如果使用配置文件中的密码，需要用户输入
        if (-not $dbPass) {
            Write-Host ""
            Write-Host "请输入数据库密码：" -ForegroundColor Yellow
            $dbPassSecure = Read-Host "   密码" -AsSecureString
            $dbPassPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPassSecure))
        } else {
            $dbPassPlain = $dbPass
        }
    }
} else {
    Write-Host "⚠️  未找到阿里云数据库配置" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "请手动输入数据库连接信息：" -ForegroundColor Yellow
    $dbHost = Read-Host "   数据库主机地址（例如：rm-xxxxx.pg.rds.aliyuncs.com）"
    $dbPort = Read-Host "   端口（默认 5432）"
    if (-not $dbPort) { $dbPort = "5432" }
    $dbUser = Read-Host "   用户名"
    $dbPassSecure = Read-Host "   密码" -AsSecureString
    $dbPassPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPassSecure))
    $dbName = Read-Host "   数据库名"
}

Write-Host ""
Write-Host "正在连接数据库并创建备份..." -ForegroundColor Green

# 设置环境变量（pg_dump 会读取）
$env:PGPASSWORD = $dbPassPlain

# 生成备份文件名
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = "backup_venues_aliyun_$timestamp.sql"
$backupPath = Join-Path $PSScriptRoot $backupFile

# 执行备份
try {
    if ($pgDumpPath -eq "pg_dump") {
        & pg_dump -h $dbHost -p $dbPort -U $dbUser -d $dbName -F p -f $backupPath 2>&1 | Out-Null
    } else {
        & $pgDumpPath -h $dbHost -p $dbPort -U $dbUser -d $dbName -F p -f $backupPath 2>&1 | Out-Null
    }
    
    if ($LASTEXITCODE -eq 0 -and (Test-Path $backupPath)) {
        $fileSize = (Get-Item $backupPath).Length / 1KB
        Write-Host ""
        Write-Host "✅ 备份成功！" -ForegroundColor Green
        Write-Host "   文件位置: $backupPath" -ForegroundColor Cyan
        Write-Host "   文件大小: $([math]::Round($fileSize, 2)) KB" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "📋 下一步：" -ForegroundColor Yellow
        Write-Host "   1. 将备份文件复制到 Mac（U盘/网盘/微信文件传输助手）" -ForegroundColor White
        Write-Host "   2. 在 Mac 上恢复数据库（使用 restore-database.sh）" -ForegroundColor White
    } else {
        Write-Host ""
        Write-Host "❌ 备份失败！" -ForegroundColor Red
        Write-Host "   请检查数据库连接信息是否正确" -ForegroundColor Yellow
        Write-Host "   确保数据库允许从你的 IP 地址连接" -ForegroundColor Yellow
    }
} catch {
    Write-Host ""
    Write-Host "❌ 备份失败：$($_.Exception.Message)" -ForegroundColor Red
} finally {
    # 清除密码环境变量
    Remove-Item Env:\PGPASSWORD -ErrorAction SilentlyContinue
}











