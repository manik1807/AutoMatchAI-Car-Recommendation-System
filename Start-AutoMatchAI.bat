@echo off
setlocal
cd /d "%~dp0"
where node >nul 2>&1
if errorlevel 1 goto neednode
where npm >nul 2>&1
if errorlevel 1 goto neednode
node -e "const [a,b]=process.versions.node.split('.').map(Number);process.exit(a>22||(a===22&&b>=13)?0:1)"
if errorlevel 1 goto neednode
if not exist ".env.local" copy /y ".env.example" ".env.local" >nul
if not exist "node_modules\.bin\next.cmd" (
  echo Installing dependencies. The first launch requires internet.
  call npm ci --no-audit --no-fund
  if errorlevel 1 goto failed
)
echo.
echo When the server says Ready, open http://localhost:3000 in your browser.
echo Keep this window open. Press Ctrl+C to stop the website.
echo.
call npm run dev
if errorlevel 1 goto failed
exit /b 0
:neednode
echo Install Node.js 24 LTS with npm from https://nodejs.org/ and reopen this launcher.
pause
exit /b 1
:failed
echo.
echo Startup stopped. Read the message above and see README.md.
pause
exit /b 1
