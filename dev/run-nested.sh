#!/usr/bin/env bash
# ==============================================================================
# dev/run-nested.sh - Creates a sandboxed environment for a nested Hyprland
# ==============================================================================
set -euo pipefail

# 1. Find the repository root (one level above dev/)
DEV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$DEV_DIR/.." && pwd)"

DOTS_CONFIG="$REPO_ROOT/dots/.config"

# 2. Temporary sandbox configuration
DEV_ENV="${XDG_RUNTIME_DIR:-/tmp}/dots-hyprland-dev"
DEV_CONFIG="$DEV_ENV/config"
DEV_DATA="$DEV_ENV/share"
DEV_CACHE="$DEV_ENV/cache"

echo "============================================================"
echo "  dots-hyprland :: Nested Test Environment"
echo "============================================================"
echo "  [+] Repo root:   $REPO_ROOT"
echo "  [+] Sandbox dir: $DEV_ENV"

# 3. Clean up and recreate the sandbox
rm -rf "$DEV_ENV"
mkdir -p "$DEV_CONFIG" "$DEV_DATA" "$DEV_CACHE"

# 4. Create isolated symlinks for the fake $XDG_CONFIG_HOME
if [[ -d "$DOTS_CONFIG" ]]; then
  echo "  [+] Linking components from dots/.config:"
  for item in "$DOTS_CONFIG"/*; do
    if [[ -e "$item" ]]; then
      base_name="$(basename "$item")"
      ln -s "$item" "$DEV_CONFIG/$base_name"
      echo "      -> $base_name -> \$XDG_CONFIG_HOME/$base_name"
    fi
  done
else
  echo "  [!] ERROR: $DOTS_CONFIG does not exist!" >&2
  echo "      Run dev/scaffold.sh first to generate the structure." >&2
  exit 1
fi

# 5. Isolate environment variables for the nested instance
export XDG_CONFIG_HOME="$DEV_CONFIG"
export XDG_DATA_HOME="$DEV_DATA"
export XDG_CACHE_HOME="$DEV_CACHE"

# Clear the parent Hyprland instance signature
unset HYPRLAND_INSTANCE_SIGNATURE
export HYPRLAND_NO_SD_NOTIFY=1

# 6. Run the nested Hyprland
MAIN_LUA="$DEV_CONFIG/hypr/hyprland.lua"

if [[ ! -f "$MAIN_LUA" ]]; then
  echo "  [!] WARNING: $MAIN_LUA not found." >&2
  echo "      Falling back to Hyprland's default configuration." >&2
  echo "============================================================"
  exec Hyprland
else
  echo "  [+] Starting nested Hyprland with $MAIN_LUA..."
  echo "============================================================"
  exec start-hyprland -c "$MAIN_LUA"
fi
