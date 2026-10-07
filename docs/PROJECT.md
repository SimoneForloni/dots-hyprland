# Project Architecture & Roadmap

This document outlines the decisions, motivations, tech stack, architecture, and roadmap for `dots-hyprland`.

---

## 1. Goal

Build a modular, long-term dotfiles ecosystem for Hyprland featuring a custom QML desktop shell built on **Quickshell**. The design is inspired by two reference projects:

- **end-4 / dots-hyprland** (`illogical-impulse`, "ii"): Functional skeleton for Hyprland integration, module structures, and workflow routines.
- **snowarch / iNiR**: Visual inspiration for the Material design language (design tokens, panels, widgets).

Instead of fork-and-modify, the codebase is being rewritten from scratch to ensure a clean architecture, deep code ownership, and ease of long-term maintenance.

---

## 2. References & Attribution

| Project                   | Role                | Usage                                                                         |
| :------------------------ | :------------------ | :---------------------------------------------------------------------------- |
| **end-4 / dots-hyprland** | Functional baseline | Keybindings, compositor integration, module layout, MVP feature set. |
| **snowarch / iNiR**       | Aesthetic baseline  | Material ii aesthetic tokens, bar, right sidebar, desktop widgets.   |

> **Note:** Both upstream projects are licensed under GPL-3.0. Re-implementing concepts and adapting existing snippets is done in full compliance with GPL-3.0. Upstream copyright headers are preserved, and credit is tracked in `docs/NOTICE.md`.

---

## 3. Technical Decisions

- **Repository Layout**: Inspired by `end-4`. A `dots/` directory mirrors `$HOME` and is installed via GNU Stow (`stow -d . -t ~ --no-folding dots`).
- **Shell Architecture**: Inspired by `iNiR`. Separated into `modules/common/` (appearance, tokens, shared widgets) and `services/`.
- **Window Manager**: Hyprland (v0.56.2+), configured using native **Lua** scripts (`hyprland.lua`).
- **IPC First**: The compositor communicates with Quickshell strictly via IPC commands (`qs ipc call <target> <function>`) without relying on global shortcuts.
- **Theme Generation**: **Matugen** generates M3 color roles in a JSON payload, consumed by the shell's `Appearance` singleton.

---

## 4. Stack & Tooling

- **Shell**: Quickshell (Qt 6 / QML + JavaScript).
- **Compositor**: Hyprland (Lua configuration format).
- **OS Services**: PipeWire, WirePlumber, NetworkManager, BlueZ, UPower, `brightnessctl`, `playerctl`.
- **Dotfiles Management**: GNU Stow, Git.
- **Quality Assurance**:
  - QML: `qmllint`, `qmlformat`
  - Lua: `lua-language-server`, `stylua`, `luacheck`
  - Bash: `shellcheck`

---

## 5. Repository Structure

```text
dots-hyprland/
├── dots/                                # Mirrors $HOME; installed via Stow
│   └── .config/
│       ├── hypr/                        # Hyprland Lua configuration
│       ├── matugen/                     # Matugen config and templates
│       └── quickshell/dots-hyprland/    # Quickshell bundle
│           ├── shell.qml
│           ├── services/                # Audio, Network, Battery, Hyprland, etc.
│           └── modules/
│               ├── common/              # Appearance, Config, M3 widgets
│               └── bar/ sidebarRight/ overview/ ...
├── assets/                              # Default fonts and wallpapers
├── dev/                                 # Dev scripts (e.g., scaffold.sh)
├── scripts/                             # Runtime helper scripts
├── sdata/                               # Installer package lists and data
├── setup                                # Entrypoint script: install, uninstall, checkdeps
├── docs/                                # Project documentation (PROJECT.md, VERSIONING.md, NOTICE.md)
├── CHANGELOG.md
├── LICENSE
└── README.md
```

---

## 6. Keybinding Philosophy

Keybindings are divided into three tiers to guarantee safety and independence:

1. **Tier 1 (Essential)**: Direct interactions with Hyprland and system utilities (`kitty`, window management, workspaces, volume/brightness hardware keys). **Does not rely on Quickshell**.
2. **Tier 2 (Shell Interactions)**: Calls Quickshell modules via IPC (launcher, overview, sidebars, OSDs).
3. **Tier 3 (Utilities & Extras)**: Workgroups, scratchpads, region capture tools, emoji pickers, submaps.

---

## 7. Development Roadmap

### MVP (Target 1.0)
* **0.0**: Standalone Hyprland Lua configuration (Tier 1 binds, `hyprlock`, fallback launcher).
* **0.1**: Core Quickshell foundation (`shell.qml`, `Config`, `Appearance`, Hyprland service, basic IPC).
* **0.2**: Material Design system tokens and primitive widgets (Button, Toggle, Slider, Card).
* **0.3**: System services integration and functional top bar.
* **0.4**: Notifications server and right sidebar (quick toggles, audio mixer, calendar).
* **0.5**: Dynamic Material You color scheme generation from wallpaper.
* **0.6**: Application launcher, workspace overview, OSDs, and session screen.
* **0.7**: Tier 3 keybindings and CLI installer (`setup`).
* **1.0**: Stabilization and daily-driver validation.

### Post 1.0 (Future Scope)
* **1.x**: Complete feature parity with `end-4` (Settings GUI, Left sidebar / AI integrations, Live overview previews).
* **2.x**: Modular styles engine, desktop widgets, customizable bar layouts.
````
