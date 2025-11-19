Param(
  [string]$ApiPort = "4000",
  [string]$WebPort = "3000"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$apiDir = Join-Path $root "Server/api"
$webDir = Join-Path $root "Web/webapp"

Write-Host "[dev] Project root: $root"

# 1) Start DB (docker compose)
Push-Location $apiDir
try {
  Write-Host "[dev] Starting Postgres/PostGIS via docker compose..."
  docker compose up -d 2>$null
} catch {
  Write-Host "[dev] 'docker compose' failed, trying 'docker-compose'"
  docker-compose up -d
}
Pop-Location

# 2) Ensure ts-node-dev is available for API
Push-Location $apiDir
if (!(Test-Path "node_modules/.bin/ts-node-dev.cmd")) {
  Write-Host "[dev] Installing ts-node-dev for API..."
  npm.cmd install -D ts-node-dev
}
Pop-Location

# 3) Prepare front-end env
Push-Location $webDir
if (!(Test-Path ".env.local")) {
  Write-Host "[dev] Creating .env.local for Web..."
  "NEXT_PUBLIC_AMAP_KEY=" | Out-File -FilePath .env.local -Encoding utf8 -Append
  "NEXT_PUBLIC_API_BASE=http://localhost:$ApiPort" | Out-File -FilePath .env.local -Encoding utf8 -Append
}
Pop-Location

# 4) Start API in new window
Write-Host "[dev] Launching API on :$ApiPort ..."
Start-Process powershell -ArgumentList "-NoExit","-Command","cd '$apiDir'; npm.cmd install; $env:PORT=$ApiPort; npm.cmd run dev"

# 5) Start Web in new window
Write-Host "[dev] Launching Web on :$WebPort ..."
Start-Process powershell -ArgumentList "-NoExit","-Command","cd '$webDir'; npm.cmd install; npm.cmd run dev -- -p $WebPort"

Write-Host "[dev] Done. API: http://localhost:$ApiPort  WEB: http://localhost:$WebPort"


