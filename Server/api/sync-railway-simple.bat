@echo off
echo Railway Database Sync Tool
echo ===========================
echo.

echo Step 1: Enter Railway DATABASE_URL
echo Get it from Railway: https://railway.app
echo Go to your database service - Connect or Variables tab
echo.
set /p RAILWAY_URL="DATABASE_URL: "

if "%RAILWAY_URL%"=="" (
    echo ERROR: DATABASE_URL is required
    pause
    exit /b 1
)

echo.
echo Step 2: Checking local database...
docker ps --filter "name=venues_pg" | findstr venues_pg >nul
if errorlevel 1 (
    echo ERROR: Local database container is not running
    echo Please run: docker compose up -d
    pause
    exit /b 1
)
echo OK: Local database is running

echo.
echo Step 3: Exporting data from Railway...
set BACKUP_FILE=railway_backup.sql

docker run --rm -v "%CD%:/backup" postgres:15 pg_dump "%RAILWAY_URL%" --data-only --table=venue --table=venue_image --table=review --table=app_user -f "/backup/%BACKUP_FILE%"

if errorlevel 1 (
    echo.
    echo ERROR: Export failed
    echo.
    echo Possible reasons:
    echo - DATABASE_URL is incorrect
    echo - Railway database is offline
    echo - Network connection problem
    echo.
    echo Please check:
    echo 1. Railway database service is online
    echo 2. DATABASE_URL is correct
    echo 3. Network connection is working
    echo.
    pause
    exit /b 1
)

echo OK: Export successful

echo.
echo Step 4: Importing to local database...
type "%BACKUP_FILE%" | docker exec -i venues_pg psql -U postgres -d venues

if errorlevel 1 (
    echo WARNING: Import may have errors
)

echo.
echo Step 5: Verifying data...
echo Venue count:
docker exec venues_pg psql -U postgres -d venues -t -c "SELECT COUNT(*) FROM venue;"

echo User count:
docker exec venues_pg psql -U postgres -d venues -t -c "SELECT COUNT(*) FROM app_user;"

echo.
echo ===========================
echo Sync completed!
echo Backup file: %BACKUP_FILE%
echo ===========================
pause



