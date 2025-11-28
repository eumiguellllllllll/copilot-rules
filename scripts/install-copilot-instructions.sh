#!/usr/bin/env bash
set -e

echo "========================================="
echo "  AUTO-INSTALLER: Copilot God Mode"
echo "========================================="

# --- Configuration ---
INSTRUCT_URL="https://raw.githubusercontent.com/LightZirconite/copilot-rules/refs/heads/main/instructions/global.instructions.md"
SETTINGS_URL="https://raw.githubusercontent.com/LightZirconite/copilot-rules/refs/heads/main/.vscode/settings.json"
TARGET_NAME="global.instructions.md"

# --- Detect OS & Directories ---
uname_out="$(uname -s)"
case "$uname_out" in
  Darwin)
    BASE_DIR="$HOME/Library/Application Support/Code/User"
    SETTINGS_FILE="$BASE_DIR/settings.json"
    PROMPTS_DIR="$BASE_DIR/prompts"
    ;;
  Linux)
    CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    BASE_DIR="$CONFIG_HOME/Code/User"
    SETTINGS_FILE="$BASE_DIR/settings.json"
    PROMPTS_DIR="$BASE_DIR/prompts"
    ;;
  *)
    echo "Unsupported OS"
    exit 1
    ;;
esac

# --- Helper: Download ---
download_file() {
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$1" -o "$2"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$2" "$1"
  else
    echo "Error: curl or wget required."
    exit 1
  fi
}

# --- Step 1: Install Instructions ---
echo "[1/3] Downloading Instructions..."
mkdir -p "$PROMPTS_DIR"
download_file "$INSTRUCT_URL" "$PROMPTS_DIR/$TARGET_NAME"

# --- Step 2: Force Update Settings ---
echo "[2/3] Overwriting VS Code Settings..."
TEMP_SETTINGS="/tmp/copilot-settings.json"
download_file "$SETTINGS_URL" "$TEMP_SETTINGS"

# Ensure directory exists
mkdir -p "$(dirname "$SETTINGS_FILE")"
cp "$TEMP_SETTINGS" "$SETTINGS_FILE"
rm -f "$TEMP_SETTINGS"

# --- Step 3: Auto-Restart VS Code ---
echo "[3/3] Restarting VS Code..."

# Kill existing processes
pkill -x Code || true
pkill -x code || true

sleep 1

# Start VS Code
if command -v code >/dev/null 2>&1; then
  code & disown
elif [ "$uname_out" = "Darwin" ]; then
  open -a "Visual Studio Code"
fi

echo "Done."