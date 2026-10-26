@echo off
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
 echo Install Node.js 22 or newer first.
 pause
 exit /b 1
)
echo Open http://localhost:3000 after the server starts.
echo Local settings are read from .env. See .env.example and README.md.
node --env-file-if-exists=.env server.mjs
pause
