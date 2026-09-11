@echo off
cd /d "%~dp0"
echo Running icon cleanup...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0cleanup-duplicates.ps1"
echo.
pause
