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
      echo "Utilisez install-copilot-instructions.bat sur Windows." >&2
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
  mkdir -p "$TARGET_DIR" || {
    echo "Echec de la creation du repertoire $TARGET_DIR" >&2
    exit 1
  }
  
  local dest="$TARGET_DIR/$TARGET_NAME"

  if [ -f "$dest" ]; then
    echo "[1/3] Suppression de l'ancienne version..."
    rm -f "$dest"
  fi

  echo "[2/3] Telechargement depuis GitHub..."
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$SOURCE" -o "$dest" || {
      echo "curl a echoue. Tentative avec wget..." >&2
      if command -v wget >/dev/null 2>&1; then
        wget -qO "$dest" "$SOURCE" || {
          echo "wget a egalement echoue." >&2
          exit 1
        }
      else
        exit 1
      fi
    }
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$dest" "$SOURCE" || {
      echo "wget a echoue." >&2
      exit 1
    }
  else
    echo "Ni curl ni wget ne sont disponibles." >&2
    exit 1
  fi

  echo "[3/3] Installation terminee: $dest"
  echo ""
  echo "========================================="
  echo "  SUCCES: Instructions Copilot installees"
  echo "========================================="
}

resolve_target_dir
install_instructions
