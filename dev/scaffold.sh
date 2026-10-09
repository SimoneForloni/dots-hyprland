#!/usr/bin/env bash
# dev/scaffold.sh - Creates the dots-hyprland repo structure stage by stage.
#
# Must be kept inside dev/ at the repo root and operates on the root directory
# (the folder above dev/), regardless of where it is executed from.
#
# Usage: dev/scaffold.sh [--stage STAGE|all] [DIRECTORY]
#   STAGE      one of 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 (default: 0.0)
#   DIRECTORY  alternative root (default: repo root)
#
# Each stage includes previous ones. Never overwrites existing files:
# safe to re-run with a higher stage when needed.
set -euo pipefail

STAGES=(0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7)
LICENSE_SRC="/usr/share/licenses/common/GPL3/license.txt"

H="dots/.config/hypr"
Q="dots/.config/quickshell/dots-hyprland"
C="$Q/modules/common"

usage() {
  cat <<'EOF'
Usage: dev/scaffold.sh [--stage STAGE|all] [DIRECTORY]
  STAGE      one of 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 (default: 0.0)
  DIRECTORY  alternative root (default: repo root)
EOF
}

stage="0.0"
target="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
while (($# > 0)); do
  case "$1" in
    -s | --stage)
      stage="${2:?missing value for --stage}"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    -*)
      echo "unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      target="$1"
      shift
      ;;
  esac
done

if [[ $stage == all ]]; then
  stage="${STAGES[-1]}"
fi

last=-1
for i in "${!STAGES[@]}"; do
  if [[ ${STAGES[$i]} == "$stage" ]]; then
    last=$i
  fi
done
if ((last < 0)); then
  echo "invalid stage: $stage (valid: ${STAGES[*]}, all)" >&2
  exit 1
fi

# ---------------------------------------------------------------- helpers

# keep <dir>: creates the directory and adds a .gitkeep ONLY if it is empty.
# If the directory already contains other files, no .gitkeep is created
# (and a leftover one is removed).
keep() {
  local dir="$target/$1"
  mkdir -p "$dir"

  # Count entries inside the directory, ignoring .gitkeep itself
  local count
  count=$(find "$dir" -mindepth 1 -maxdepth 1 ! -name '.gitkeep' | wc -l)

  if ((count == 0)); then
    if [[ ! -e "$dir/.gitkeep" ]]; then
      : >"$dir/.gitkeep"
    fi
  else
    rm -f "$dir/.gitkeep"
  fi
}

# put <file>: writes stdin to file without overwriting.
# When a new file is created, a now-useless .gitkeep in its directory is removed.
put() {
  local f="$target/$1"
  mkdir -p "$(dirname "$f")"
  if [[ -e $f ]]; then
    cat >/dev/null
    echo "already exists: $1"
  else
    cat >"$f"
    rm -f "$(dirname "$f")/.gitkeep"
    echo "created:        $1"
  fi
}

# lua_stub <file relative to hypr/> <description>
lua_stub() {
  put "$H/$1" <<EOF
-- $1: $2
EOF
}

# qml_singleton <Name>: empty singleton in modules/common
qml_singleton() {
  put "$C/$1.qml" <<'EOF'
pragma Singleton
import Quickshell

Singleton {
}
EOF
}

install_license() {
  if [[ -e $target/LICENSE ]]; then
    echo "already exists: LICENSE"
  elif [[ -r $LICENSE_SRC ]]; then
    cp "$LICENSE_SRC" "$target/LICENSE"
    echo "created:        LICENSE (GPL-3.0, from $LICENSE_SRC)"
  else
    echo "WARNING: GPL-3.0 text not found in $LICENSE_SRC, copy LICENSE manually" >&2
  fi
}

# ---------------------------------------------------------------- stages

stage_0_0() {
  put README.md <<'EOF'
# dots-hyprland

Dotfiles for Hyprland featuring a QML shell built on Quickshell, with Material You aesthetics.
Written from scratch, inspired by end-4/dots-hyprland and snowarch/iNiR.

## Status

In development: stage 0.0 (Standalone Hyprland, no shell).

## Requirements

- Arch Linux or derivatives (developed and tested on CachyOS)
- Hyprland **0.56.2** (tested version; Lua config requires >= 0.55)
- GNU Stow

## Temporary Installation

First back up `~/.config/hypr`, then run:

```sh
stow -d . -t ~ --no-folding dots
```

## License

GPL-3.0
EOF

  put CHANGELOG.md <<'EOF'
# Changelog

Format inspired by Keep a Changelog; versioning is described in
`docs/VERSIONING.md`.

## [Unreleased]

### Added

- Initial repo structure.
EOF

  put .gitignore <<'EOF'
*.swp
*.log
.DS_Store
__pycache__/
/cache/
EOF

  put .editorconfig <<'EOF'
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.{lua,json,md,yml,yaml,toml}]
indent_style = space
indent_size = 2

[*.qml]
indent_style = space
indent_size = 4

[*.sh]
indent_style = space
indent_size = 2
EOF

  put stylua.toml <<'EOF'
indent_type = "Spaces"
indent_width = 2
EOF

  put .luacheckrc <<'EOF'
-- Hyprland exposes the global table `hl`
globals = { "hl" }
EOF

  put .pre-commit-config.yaml <<'EOF'
repos:
  - repo: local
    hooks:
      - id: stylua
        name: stylua
        entry: stylua --check
        language: system
        types: [lua]
      - id: luacheck
        name: luacheck
        entry: luacheck
        language: system
        types: [lua]
      - id: shellcheck
        name: shellcheck
        entry: shellcheck
        language: system
        types: [shell]
      # Enable at 0.1 (check the binary name: qmllint or qmllint-qt6):
      # - id: qmllint
      #   name: qmllint
      #   entry: qmllint
      #   language: system
      #   files: \.qml$
EOF

  install_license

  put "$H/hyprland.lua" <<'EOF'
-- hyprland.lua: only require() calls, no logic.
-- Order matters: monitors first.
-- TODO: check on the wiki how Hyprland resolves require() from the config folder.
require("monitors")
require("env")
require("autostart")
require("appearance")
require("animations")
require("input")
require("rules")
require("binds.essential")
-- 0.3: require("binds.shell")
-- 0.7: require("binds.extras")
EOF
  lua_stub monitors.lua "monitor configuration (must be loaded first)"
  lua_stub env.lua "environment variables"
  lua_stub autostart.lua "programs to start with the session"
  lua_stub appearance.lua "base appearance: gaps, borders, decorations"
  lua_stub animations.lua "base animations"
  lua_stub input.lua "keyboard, mouse, touchpad"
  lua_stub rules.lua "window and layer rules"
  lua_stub binds/essential.lua "level 1: binds that only talk to Hyprland and system programs, never to the shell"

  keep docs
}

stage_0_1() {
  put "$Q/shell.qml" <<'EOF'
import Quickshell

ShellRoot {
}
EOF
  for n in Appearance Config GlobalStates; do
    qml_singleton "$n"
  done
  keep "$Q/services"
  for d in functions models utils widgets; do
    keep "$C/$d"
  done
}

stage_0_2() {
  keep "$Q/modules/bar"
  keep assets/fonts
}

stage_0_3() {
  put "$H/qs.lua" <<'EOF'
-- qs.lua: IPC helper towards Quickshell.
-- All binds towards the shell go through here (exec_cmd + qs ipc call).
local M = {}
local SHELL = "qs -c dots-hyprland" -- name of the Quickshell config

function M.call(target, fn)
  return hl.dsp.exec_cmd(string.format("%s ipc call %s %s", SHELL, target, fn))
end

return M
EOF
  lua_stub binds/shell.lua "level 2: binds towards the shell via IPC (uses qs.lua)"
}

stage_0_4() {
  keep "$Q/modules/sidebarRight"
  keep "$Q/modules/notificationPopup"
}

stage_0_5() {
  put "dots/.config/matugen/config.toml" <<'EOF'
# matugen: templates and output (stage 0.5)
EOF
  keep "dots/.config/matugen/templates"
  keep scripts
}

stage_0_6() {
  keep "$Q/modules/overview"
  keep "$Q/modules/onScreenDisplay"
  keep "$Q/modules/sessionScreen"
}

stage_0_7() {
  keep sdata/dist-arch
  keep sdata/lib
  put setup <<'EOF'
#!/usr/bin/env bash
# setup: installer entrypoint. Planned subcommands: install, uninstall, checkdeps.
set -euo pipefail

echo "setup: not implemented yet (stage 0.7)" >&2
exit 1
EOF
  chmod +x "$target/setup"
  lua_stub binds/extras.lua "level 3: comfort binds"
}

# ---------------------------------------------------------------- main

mkdir -p "$target"
for i in "${!STAGES[@]}"; do
  if ((i <= last)); then
    s="${STAGES[$i]}"
    echo "== stage $s"
    "stage_${s//./_}"
  fi
done

if [[ ! -d $target/.git ]] && command -v git >/dev/null 2>&1; then
  git init -q -b main "$target"
  echo "git: repository initialized (branch main)"
fi

cat <<EOF

Done: $target (up to stage $stage).
Next steps:
  - check that $target/docs/ contains PROJECT.md and VERSIONING.md
  - check LICENSE and README
  - make the first commit for 0.0.1
EOF
