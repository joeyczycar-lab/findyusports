@echo off
setlocal ENABLEDELAYEDEXPANSION
set ROOT=%~dp0..
set API=%ROOT%\Server\api
set WEB=%ROOT%\Web\webapp

echo [dev] Starting Postgres/PostGIS via docker compose
pushd "%API%"
docker compose up -d
popd

echo [dev] Ensure ts-node-dev for API
pushd "%API%"
if not exist node_modules\.bin\ts-node-dev.cmd npm.cmd install -D ts-node-dev
start powershell -NoExit -Command "cd '%API%'; npm.cmd install; $env:PORT=4000; npm.cmd run dev"
popd

echo [dev] Prepare Web env
pushd "%WEB%"
if not exist .env.local (
  echo NEXT_PUBLIC_AMAP_KEY=>> .env.local
  echo NEXT_PUBLIC_API_BASE=http://localhost:4000>> .env.local
)
start powershell -NoExit -Command "cd '%WEB%'; npm.cmd install; npm.cmd run dev -- -p 3000"
popd

echo [dev] Done. API http://localhost:4000  WEB http://localhost:3000
exit /b 0


