@echo off
chcp 65001 >nul
echo ========================================
echo Git Commit and Push (Frontend)
echo ========================================
echo.

cd /d "%~dp0"
cd ../..

echo Current directory: %CD%
echo.

echo Checking git status...
git status

echo.
echo Staging all changes...
git add .

echo.
echo Current changes:
git status --short

echo.
set /p COMMIT_MSG="Enter commit message: "

if "%COMMIT_MSG%"=="" (
    set COMMIT_MSG=Update: Add sport category collections on homepage
)

echo.
echo Committing changes...
git commit -m "%COMMIT_MSG%"

if errorlevel 1 (
    echo.
    echo ERROR: Commit failed
    pause
    exit /b 1
)

echo.
echo Pushing to remote...
git push

if errorlevel 1 (
    echo.
    echo WARNING: Push failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo Successfully committed and pushed!
echo ========================================
pause


