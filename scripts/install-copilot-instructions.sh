#!/usr/bin/env bash
set -euo pipefail

DEFAULT_URL="https://raw.githubusercontent.com/LightZirconite/copilot-rules/refs/heads/main/instructions/global.instructions.md"

if [ -n "${1:-}" ]; then
  SOURCE="$1"
else
  SOURCE="$DEFAULT_URL"
fi

TARGET_NAME="${2:-global.instructions.md}"

resolve_target_dir() {
  local uname_out="$(uname -s)"
  declare -a candidates=()
  case "$uname_out" in
    Darwin)
      local base="$HOME/Library/Application Support"
      candidates+=("$base/Code/User/prompts")
      candidates+=("$base/Code - Insiders/User/prompts")
      ;;
    Linux)
      local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
      candidates+=("$config_home/Code/User/prompts")
      candidates+=("$config_home/Code - Insiders/User/prompts")
      ;;
    MINGW*|MSYS*|CYGWIN*)
      echo "Use install-copilot-instructions.bat on Windows." >&2
      exit 1
      ;;
    *)
      local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
      candidates+=("$config_home/Code/User/prompts")
      ;;
  esac

  for dir in "${candidates[@]}"; do
    if [ -d "$(dirname "$dir")" ]; then
      TARGET_DIR="$dir"
      break
    fi
  done

  if [ -z "${TARGET_DIR:-}" ]; then
    TARGET_DIR="${candidates[0]}"
  fi
}

download_file() {
  local url="$1"
  local dest="$2"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$dest" || {
      if command -v wget >/dev/null 2>&1; then
        wget -qO "$dest" "$url" || return 1
      else
        return 1
      fi
    }
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$dest" "$url" || return 1
  else
    echo "Neither curl nor wget are available." >&2
    return 1
  fi
  return 0
}

install_instructions() {
  mkdir -p "$TARGET_DIR" || {
    echo "Failed to create directory $TARGET_DIR" >&2
    exit 1
  }
  
  local dest="$TARGET_DIR/$TARGET_NAME"

  if [ -f "$dest" ]; then
    echo "[1/4] Removing previous version..."
    rm -f "$dest"
  fi

  echo "[2/4] Downloading from GitHub..."
  download_file "$SOURCE" "$dest" || {
    echo "Download failed." >&2
    exit 1
  }

  echo "[3/4] Installation complete: $dest"
  echo ""
  echo "========================================="
  echo "  SUCCESS: Copilot instructions installed"
  echo "========================================="
  echo ""

  # VS Code configuration
  local vscode_settings=""
  if [ "$(uname -s)" = "Darwin" ]; then
    vscode_settings="$HOME/Library/Application Support/Code/User/settings.json"
  else
    local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
    vscode_settings="$config_home/Code/User/settings.json"
  fi

  echo "[4/4] VS Code configuration..."
  echo ""
  echo "For Copilot to use these instructions, your settings.json must contain:"
  echo '  "github.copilot.chat.codeGeneration.useInstructionFiles": true'
  echo ""
  read -p "Do you want to update your VS Code configuration automatically? (y/n): " -n 1 -r
  echo ""

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Downloading recommended configuration..."
    local settings_url="https://raw.githubusercontent.com/LightZirconite/copilot-rules/refs/heads/main/.vscode/settings.json"
    local temp_settings="/tmp/copilot-rules-settings.json"
    
    download_file "$settings_url" "$temp_settings" || {
      echo "WARNING: Unable to download configuration." >&2
      echo "Manually add this line to $vscode_settings:"
      echo '  "github.copilot.chat.codeGeneration.useInstructionFiles": true'
      return 0
    }

    if [ -f "$vscode_settings" ]; then
      echo "Backing up your current configuration..."
      cp "$vscode_settings" "$vscode_settings.backup"
      echo "Backup created: $vscode_settings.backup"
    fi

    mkdir -p "$(dirname "$vscode_settings")"
    cp "$temp_settings" "$vscode_settings"
    rm -f "$temp_settings"
    echo "VS Code configuration updated successfully!"
  else
    echo ""
    echo "Manual configuration required:"
    echo "1. Open VS Code Settings (Ctrl+, or Cmd+,)"
    echo "2. Click 'Open Settings (JSON)' (icon in top right)"
    echo "3. Add this line:"
    echo '   "github.copilot.chat.codeGeneration.useInstructionFiles": true'
    echo ""
  fi

  echo ""
  echo "Reload VS Code: Ctrl+Shift+P -> Developer: Reload Window"
  echo ""
}

resolve_target_dir
install_instructions
