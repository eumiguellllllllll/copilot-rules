@echo off
setlocal enabledelayedexpansion

set "PAUSE_ON_ERROR=0"
call :detectPauseMode

set "DEFAULT_URL=https://raw.githubusercontent.com/LightZirconite/copilot-rules/main/instructions/global.instructions.md"
for %%I in ("%~dp0..") do set "REPO_ROOT=%%~fI"
set "DEFAULT_FILE=%REPO_ROOT%\instructions\global.instructions.md"

if "%~1"=="" (
  if exist "%DEFAULT_FILE%" (
    set "SOURCE=%DEFAULT_FILE%"
  ) else (
    set "SOURCE=%DEFAULT_URL%"
  )
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

if exist "%SOURCE%" (
  echo [1/2] Source locale detectee: %SOURCE%
  copy /Y "%SOURCE%" "%DEST_FILE%" >nul
  if errorlevel 1 call :fail "Impossible de copier le fichier local."
  echo [2/2] Fichier installe avec succes: %DEST_FILE%
) else (
  echo [1/2] Telechargement depuis: %SOURCE%
  call :download "%SOURCE%" "%DEST_FILE%"
  if errorlevel 1 call :fail "Echec du telechargement."
  echo [2/2] Fichier telecharge et installe: %DEST_FILE%
)

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
set "CMD_LINE=%CMDCMDLINE%"
if not defined CMD_LINE (
  set "PAUSE_ON_ERROR=1"
  exit /b 0
)
set "WITH_C_LOW=%CMD_LINE:/c=%"
if not "%WITH_C_LOW%"=="%CMD_LINE%" set "PAUSE_ON_ERROR=1"
set "WITH_C_UP=%CMD_LINE:/C=%"
if not "%WITH_C_UP%"=="%CMD_LINE%" set "PAUSE_ON_ERROR=1"
set "WITH_K_LOW=%CMD_LINE:/k=%"
if not "%WITH_K_LOW%"=="%CMD_LINE%" set "PAUSE_ON_ERROR=0"
set "WITH_K_UP=%CMD_LINE:/K=%"
if not "%WITH_K_UP%"=="%CMD_LINE%" set "PAUSE_ON_ERROR=0"
exit /b 0
