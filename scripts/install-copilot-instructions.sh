#!/usr/bin/env bash
set -euo pipefail

DEFAULT_URL="https://raw.githubusercontent.com/LightZirconite/copilot-rules/main/instructions/global.instructions.md"
SOURCE="${1:-$DEFAULT_URL}"
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
      echo "Use install-copilot-instructions.bat on Windows environments." >&2
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

install_instructions() {
  mkdir -p "$TARGET_DIR"
  local dest="$TARGET_DIR/$TARGET_NAME"

  if [ -f "$SOURCE" ]; then
    cp "$SOURCE" "$dest"
  else
    if command -v curl >/dev/null 2>&1; then
      curl -fsSL "$SOURCE" -o "$dest"
    elif command -v wget >/dev/null 2>&1; then
      wget -qO "$dest" "$SOURCE"
    else
      echo "Neither curl nor wget is available to download $SOURCE." >&2
      exit 1
    fi
  fi

  echo "Copilot instructions installed to $dest"
}

resolve_target_dir
install_instructions
