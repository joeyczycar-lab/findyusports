@echo off
echo ========================================
echo Railway Database Sync
echo ========================================
echo.

echo Step 1: Exporting data from Railway...
echo This may take a few minutes, please wait...
docker run --rm -v "%CD%:/backup" postgres:17 pg_dump "postgresql://postgres:wzQlXXtAwygbvCXsNkDuWxqTnYoimUtE@yamanote.proxy.rlwy.net:29122/railway" --data-only --table=venue --table=venue_image --table=review --table=app_user -f /backup/railway_backup.sql

if errorlevel 1 (
    echo.
    echo ERROR: Export failed
    pause
    exit /b 1
)

echo.
echo Step 2: Importing to local database...
type railway_backup.sql | docker exec -i venues_pg psql -U postgres -d venues

echo.
echo Step 3: Verifying data...
echo Venue count:
docker exec venues_pg psql -U postgres -d venues -t -c "SELECT COUNT(*) FROM venue;"
echo.
echo User count:
docker exec venues_pg psql -U postgres -d venues -t -c "SELECT COUNT(*) FROM app_user;"

echo.
echo ========================================
echo Sync completed!
echo ========================================
pause

