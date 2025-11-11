@echo off
setlocal enabledelayedexpansion

set "DEFAULT_URL=https://raw.githubusercontent.com/LightZirconite/copilot-rules/main/instructions/global.instructions.md"
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
if errorlevel 1 (
  echo Failed to resolve the VS Code Copilot instructions directory.& exit /b 1
)

if not exist "%TARGET_DIR%" (
  mkdir "%TARGET_DIR%" 2>nul
  if errorlevel 1 (
    echo Unable to create "%TARGET_DIR%".& exit /b 1
  )
)

set "DEST_FILE=%TARGET_DIR%\%TARGET_NAME%"

if exist "%SOURCE%" (
  copy /Y "%SOURCE%" "%DEST_FILE%" >nul
  if errorlevel 1 (
    echo Failed to copy instructions from "%SOURCE%".& exit /b 1
  )
) else (
  call :download "%SOURCE%" "%DEST_FILE%"
  if errorlevel 1 exit /b 1
)

echo Copilot instructions installed to "%DEST_FILE%".
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
    echo APPDATA environment variable not found.& exit /b 1
  )
)
set "%~1=%TARGET%"
exit /b 0

:download
set "URL=%~1"
set "DEST=%~2"
where curl >nul 2>&1
if not errorlevel 1 (
  curl -fsSL "%URL%" -o "%DEST%"
  if not errorlevel 1 exit /b 0
  echo curl failed to download "%URL%".& goto :tryPowerShell
) else (
  echo curl command not found. Falling back to PowerShell.& goto :tryPowerShell
)

:tryPowerShell
powershell -NoProfile -Command "try { Invoke-WebRequest -Uri '%URL%' -OutFile '%DEST%' -UseBasicParsing } catch { exit 1 }"
if errorlevel 1 (
  echo Failed to download "%URL%".& exit /b 1
)
exit /b 0
