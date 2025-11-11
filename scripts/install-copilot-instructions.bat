@echo off
setlocal enabledelayedexpansion

set "PAUSE_ON_ERROR=0"
call :detectPauseMode

set "DEFAULT_URL=https://raw.githubusercontent.com/LightZirconite/copilot-rules/refs/heads/main/instructions/global.instructions.md"

if "%~1"=="" (
  set "SOURCE=%DEFAULT_URL%"
) else (
  set "SOURCE=%~1"
)
if "%~2"=="" (
  set "TARGET_NAME=global.instructions.md"
) else (
  set "TARGET_NAME=%~2"
)

call :detectTarget TARGET_DIR
if errorlevel 1 call :fail "Failed to resolve the VS Code Copilot instructions directory."

if not exist "%TARGET_DIR%" (
  mkdir "%TARGET_DIR%" 2>nul
  if errorlevel 1 call :fail "Unable to create "%TARGET_DIR%"."
)

set "DEST_FILE=%TARGET_DIR%\%TARGET_NAME%"

if exist "%DEST_FILE%" (
  echo [1/3] Suppression de l'ancienne version...
  del /F /Q "%DEST_FILE%" >nul 2>&1
)

echo [2/3] Telechargement depuis GitHub...
call :download "%SOURCE%" "%DEST_FILE%"
if errorlevel 1 call :fail "Echec du telechargement."
echo [3/3] Installation terminee: %DEST_FILE%

echo.
echo =========================================
echo   SUCCES: Instructions Copilot installees
echo =========================================
echo.
pause
exit /b 0

:detectTarget
set "TARGET="
set "APPDATA_DIR=%APPDATA%"
if defined APPDATA_DIR (
  if exist "%APPDATA_DIR%\Code\User" set "TARGET=%APPDATA_DIR%\Code\User\prompts"
  if not defined TARGET if exist "%APPDATA_DIR%\Code - Insiders\User" set "TARGET=%APPDATA_DIR%\Code - Insiders\User\prompts"
)
if not defined TARGET (
  if defined APPDATA_DIR (
    set "TARGET=%APPDATA_DIR%\Code\User\prompts"
  ) else (
    call :fail "APPDATA environment variable not found."
  )
)
set "%~1=%TARGET%"
exit /b 0

:download
set "URL=%~1"
set "DEST=%~2"
echo Downloading from %URL%...
where curl >nul 2>&1
if not errorlevel 1 (
  curl -fsSL "%URL%" -o "%DEST%"
  if not errorlevel 1 exit /b 0
  echo curl failed to download "%URL%". Falling back to PowerShell...
  goto :tryPowerShell
) else (
  echo curl not found. Falling back to PowerShell...
  goto :tryPowerShell
)

:tryPowerShell
powershell -NoProfile -Command "try { Invoke-WebRequest -Uri '%URL%' -OutFile '%DEST%' -UseBasicParsing } catch { exit 1 }"
if errorlevel 1 call :fail "Failed to download %URL%."
exit /b 0

:fail
echo.
echo ERROR: %~1
echo.
if "%PAUSE_ON_ERROR%"=="1" (
  pause
) else (
  echo Press any key to close...
  pause >nul
)
exit /b 1

:detectPauseMode
REM Force pause unconditionally for clarity
set "PAUSE_ON_ERROR=1"
exit /b 0
