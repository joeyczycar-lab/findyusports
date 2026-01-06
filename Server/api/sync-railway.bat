@echo off
chcp 65001 >nul
echo ========================================
echo Railway Database Sync to Local
echo ========================================
echo.

echo This tool will export data from Railway and import to local database
echo.

echo Step 1: Get Railway DATABASE_URL
echo ----------------------------------------
echo 1. Login Railway: https://railway.app
echo 2. Go to your database service
echo 3. Click "Connect" or "Variables" tab
echo 4. Copy DATABASE_URL or POSTGRES_URL
echo.

set /p RAILWAY_URL="Enter Railway DATABASE_URL: "

if "%RAILWAY_URL%"=="" (
    echo [ERROR] DATABASE_URL cannot be empty
    pause
    exit /b 1
)

echo.
echo Step 2: Check local database container
echo ----------------------------------------
docker ps --filter "name=venues_pg" | findstr venues_pg >nul
if errorlevel 1 (
    echo [ERROR] Local database container is not running
    echo Please run: docker compose up -d
    pause
    exit /b 1
)
echo [OK] Local database container is running

echo.
echo Step 3: Export data from Railway
echo ----------------------------------------
set BACKUP_FILE=railway_data_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%.sql
set BACKUP_FILE=%BACKUP_FILE: =0%

echo Exporting data to: %BACKUP_FILE%
echo.

docker run --rm -v "%CD%:/backup" postgres:15 pg_dump "%RAILWAY_URL%" --data-only --table=venue --table=venue_image --table=review --table=app_user -f "/backup/%BACKUP_FILE%" 2>nul

if errorlevel 1 (
    echo [ERROR] Data export failed
    echo.
    echo Possible reasons:
    echo 1. DATABASE_URL is incorrect
    echo 2. Railway database is not accessible
    echo 3. Network connection problem
    echo.
    echo Alternative: Use Railway Query to export manually
    pause
    exit /b 1
)

echo [OK] Data export successful

echo.
echo Step 4: Import data to local database
echo ----------------------------------------
echo Importing data...
echo.

type "%BACKUP_FILE%" | docker exec -i venues_pg psql -U postgres -d venues >nul 2>&1

if errorlevel 1 (
    echo [WARNING] Import may have errors, but continuing...
)

echo [OK] Data import completed

echo.
echo Step 5: Verify data
echo ----------------------------------------
echo Venue count:
docker exec venues_pg psql -U postgres -d venues -t -c "SELECT COUNT(*) FROM venue;" 2>nul

echo User count:
docker exec venues_pg psql -U postgres -d venues -t -c "SELECT COUNT(*) FROM app_user;" 2>nul

echo.
echo ========================================
echo Sync completed!
echo ========================================
echo.
echo Backup file saved: %BACKUP_FILE%
echo You can delete the backup file to save space
echo.
pause

