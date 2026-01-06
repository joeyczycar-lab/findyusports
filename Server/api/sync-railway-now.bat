@echo off
echo Syncing Railway database to local...
echo.

REM Check local database
docker ps --filter "name=venues_pg" | findstr venues_pg >nul
if errorlevel 1 (
    echo ERROR: Local database container not running
    echo Please run: docker compose up -d
    pause
    exit /b 1
)

echo Step 1: Exporting from Railway...
docker run --rm -v "%CD%:/backup" postgres:15 pg_dump "postgresql://postgres:wzQlXXtAwygbvCXsNkDuWxqTnYoimUtE@yamanote.proxy.rlwy.net:29122/railway" --data-only --table=venue --table=venue_image --table=review --table=app_user -f /backup/railway_backup.sql

if errorlevel 1 (
    echo.
    echo ERROR: Export failed
    echo Check if Railway database is online
    pause
    exit /b 1
)

echo.
echo Step 2: Importing to local database...
type railway_backup.sql | docker exec -i venues_pg psql -U postgres -d venues

echo.
echo Step 3: Verifying...
docker exec venues_pg psql -U postgres -d venues -t -c "SELECT COUNT(*) FROM venue;"

echo.
echo Done!
pause



