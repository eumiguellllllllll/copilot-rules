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
  echo [1/4] Removing previous version...
  del /F /Q "%DEST_FILE%" >nul 2>&1
)

echo [2/4] Downloading from GitHub...
call :download "%SOURCE%" "%DEST_FILE%"
if errorlevel 1 call :fail "Download failed."
echo [3/4] Installation complete: %DEST_FILE%

echo.
echo =========================================
echo   SUCCESS: Copilot instructions installed
echo =========================================
echo.

REM VS Code configuration
set "VSCODE_SETTINGS=%APPDATA%\Code\User\settings.json"
echo [4/4] VS Code configuration...
echo.
echo For Copilot to use these instructions, your settings.json must contain:
echo   "github.copilot.chat.codeGeneration.useInstructionFiles": true
echo.
choice /C YN /M "Do you want to update your VS Code configuration automatically"
if errorlevel 2 goto :skipConfig
if errorlevel 1 goto :updateConfig

:updateConfig
echo.
echo Downloading recommended configuration...
set "SETTINGS_URL=https://raw.githubusercontent.com/LightZirconite/copilot-rules/refs/heads/main/.vscode/settings.json"
set "TEMP_SETTINGS=%TEMP%\copilot-rules-settings.json"
call :download "%SETTINGS_URL%" "%TEMP_SETTINGS%"
if errorlevel 1 (
  echo WARNING: Unable to download configuration.
  echo Manually add this line to %VSCODE_SETTINGS%:
  echo   "github.copilot.chat.codeGeneration.useInstructionFiles": true
  goto :skipConfig
)
if exist "%VSCODE_SETTINGS%" (
  echo Backing up your current configuration...
  copy /Y "%VSCODE_SETTINGS%" "%VSCODE_SETTINGS%.backup" >nul
  echo Backup created: %VSCODE_SETTINGS%.backup
)
copy /Y "%TEMP_SETTINGS%" "%VSCODE_SETTINGS%" >nul
del /F /Q "%TEMP_SETTINGS%" >nul 2>&1
echo VS Code configuration updated successfully!
goto :end

:skipConfig
echo.
echo Manual configuration required:
echo 1. Open VS Code Settings (Ctrl+,)
echo 2. Click "Open Settings (JSON)" (icon in top right)
echo 3. Add this line:
echo    "github.copilot.chat.codeGeneration.useInstructionFiles": true
echo.

:end
echo.
echo Reload VS Code: Ctrl+Shift+P -^> Developer: Reload Window
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
