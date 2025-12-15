# Cursor 更新路径修复脚本
# 用于解决 Cursor 更新安装失败的问题

Write-Host "=== Cursor 更新路径配置工具 ===" -ForegroundColor Cyan
Write-Host ""

# 检查并创建 Cursor.exe 符号链接
Write-Host "0. 修复 Cursor.exe 路径问题..." -ForegroundColor Yellow
$sourceExe = "F:\网站\cursor\cursor\_\Cursor.exe"
$targetExe = "F:\网站\cursor\cursor\Cursor.exe"

if (Test-Path $sourceExe) {
    if (Test-Path $targetExe) {
        $existing = Get-Item $targetExe -ErrorAction SilentlyContinue
        if ($existing.LinkType -ne "SymbolicLink") {
            Write-Host "   删除现有文件..." -ForegroundColor Yellow
            Remove-Item $targetExe -Force -ErrorAction SilentlyContinue
        } else {
            Write-Host "   ✓ 符号链接已存在" -ForegroundColor Green
        }
    }
    
    if (-not (Test-Path $targetExe)) {
        try {
            $cmd = "cmd /c mklink `"$targetExe`" `"$sourceExe`""
            Invoke-Expression $cmd | Out-Null
            Write-Host "   ✓ 已创建 Cursor.exe 符号链接" -ForegroundColor Green
        } catch {
            Write-Host "   ✗ 符号链接创建失败，尝试复制文件..." -ForegroundColor Yellow
            Copy-Item $sourceExe $targetExe -Force
            Write-Host "   ✓ 已复制 Cursor.exe" -ForegroundColor Green
        }
    }
} else {
    Write-Host "   ⚠ 源文件不存在: $sourceExe" -ForegroundColor Yellow
}

Write-Host ""

# 设置新的更新路径
$newUpdatePath = "F:\网站\cursor\updates"
$newCachePath = "F:\网站\cursor\cache"

# 1. 创建更新目录
Write-Host "1. 创建更新目录..." -ForegroundColor Yellow
if (-not (Test-Path $newUpdatePath)) {
    New-Item -ItemType Directory -Path $newUpdatePath -Force | Out-Null
    Write-Host "   ✓ 已创建: $newUpdatePath" -ForegroundColor Green
} else {
    Write-Host "   ✓ 已存在: $newUpdatePath" -ForegroundColor Green
}

# 2. 创建缓存目录
Write-Host "2. 创建缓存目录..." -ForegroundColor Yellow
if (-not (Test-Path $newCachePath)) {
    New-Item -ItemType Directory -Path $newCachePath -Force | Out-Null
    Write-Host "   ✓ 已创建: $newCachePath" -ForegroundColor Green
} else {
    Write-Host "   ✓ 已存在: $newCachePath" -ForegroundColor Green
}

# 3. 设置环境变量
Write-Host "3. 设置环境变量..." -ForegroundColor Yellow
try {
    [System.Environment]::SetEnvironmentVariable("CURSOR_UPDATE_PATH", $newUpdatePath, "User")
    Write-Host "   ✓ 已设置 CURSOR_UPDATE_PATH = $newUpdatePath" -ForegroundColor Green
} catch {
    Write-Host "   ✗ 设置失败: $_" -ForegroundColor Red
}

# 4. 检查并清理锁文件
Write-Host "4. 检查更新锁文件..." -ForegroundColor Yellow
$lockPaths = @(
    "$env:LOCALAPPDATA\Cursor",
    "$env:APPDATA\Cursor",
    "F:\网站\cursor\cursor"
)

$lockFilesFound = $false
foreach ($basePath in $lockPaths) {
    if (Test-Path $basePath) {
        $lockFiles = Get-ChildItem -Path $basePath -Recurse -Filter "*.lock" -ErrorAction SilentlyContinue | 
            Where-Object { $_.Name -like "*update*" -or $_.Name -like "*install*" }
        if ($lockFiles) {
            $lockFilesFound = $true
            Write-Host "   找到锁文件:" -ForegroundColor Yellow
            $lockFiles | ForEach-Object {
                Write-Host "     - $($_.FullName)" -ForegroundColor Yellow
                try {
                    Remove-Item $_.FullName -Force -ErrorAction Stop
                    Write-Host "       ✓ 已删除" -ForegroundColor Green
                } catch {
                    Write-Host "       ✗ 删除失败: $_" -ForegroundColor Red
                }
            }
        }
    }
}

if (-not $lockFilesFound) {
    Write-Host "   ✓ 未找到锁文件" -ForegroundColor Green
}

# 5. 验证配置
Write-Host ""
Write-Host "=== 配置总结 ===" -ForegroundColor Cyan
Write-Host "更新目录: $newUpdatePath" -ForegroundColor White
Write-Host "缓存目录: $newCachePath" -ForegroundColor White
$envVar = [System.Environment]::GetEnvironmentVariable("CURSOR_UPDATE_PATH", "User")
if ($envVar) {
    Write-Host "环境变量: CURSOR_UPDATE_PATH = $envVar" -ForegroundColor White
} else {
    Write-Host "环境变量: 未设置" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== 下一步操作 ===" -ForegroundColor Cyan
Write-Host "1. 重启 Cursor 以使环境变量生效" -ForegroundColor White
Write-Host "2. 尝试再次更新 Cursor" -ForegroundColor White
Write-Host "3. 如果仍然失败，请检查:" -ForegroundColor White
Write-Host "   - 磁盘空间是否充足" -ForegroundColor White
Write-Host "   - 目录权限是否正确" -ForegroundColor White
Write-Host "   - 防火墙/杀毒软件是否阻止" -ForegroundColor White
Write-Host ""
Write-Host "按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")



