# dots-hyprland

A custom, modern desktop environment built for **Hyprland** using **Quickshell** (QML/Qt6), designed with Google's **Material Design 3 (Material You)** aesthetics.

![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)
![Hyprland: 0.56.2](https://img.shields.io/badge/Hyprland-0.56.2-heroic.svg)
![Quickshell: Qt6](https://img.shields.io/badge/Shell-Quickshell--Qt6-green.svg)

---

## 🌟 Overview

**dots-hyprland** is a grounds-up dotfiles configuration and desktop shell tailored for Arch Linux and derivatives. Instead of relying on traditional GTK/Qt status bars or monolithic shells, it integrates a lightweight, fully modular QML shell written for [Quickshell](https://quickshell.outfoxxed.me/), featuring dynamic Material You theming and seamless IPC integration with Hyprland.

### Core Inspirations
- **[end-4 / dots-hyprland (illogical-impulse)](https://github.com/end-4/dots-hyprland):** Functional skeleton, Hyprland compositor interaction, keybindings, and module structure.
- **[snowarch / iNiR](https://github.com/snowarch/iNiR):** Visual identity based on the *Material ii* style, design tokens, sidebar concepts, and widget design.

---

## 🛠️ Stack & Technologies

* **Window Manager / Compositor:** [Hyprland](https://hyprland.org/) (`v0.56.2+`), configured natively in **Lua**.
* **Desktop Shell:** [Quickshell](https://quickshell.outfoxxed.me/) (Qt 6 & QML).
* **Color Palette / Dynamic Theming:** `matugen` (Generates M3 roles from wallpaper to JSON token mappings).
* **System Services:** PipeWire / WirePlumber (Audio), NetworkManager (Network), BlueZ (Bluetooth), UPower (Battery), `brightnessctl`, `playerctl`.
* **Dotfiles Management:** [GNU Stow](https://www.gnu.org/software/stow/).
* **Target OS:** Arch Linux / CachyOS and derivatives.

---

## 🚀 Key Features

* 🎨 **Material Design 3 System:** Single source of truth for colors, corner radii, elevation, spacing, and motion curves via a centralized `Appearance` singleton.
* ⚡ **Decoupled Architecture:** IPC-first communication between Hyprland and Quickshell (`qs ipc call`).
* 🔒 **Layered Keybindings:** 3-tier keybinding structure ensuring the system remains controllable even if the shell reloads or crashes.
* 🧩 **Modular Shell Layout:** Lazy-loaded panels (Launcher, Sidebar, OSD, Notifications, Overview) to maintain low resource usage.
* 🛠️ **Lua Hyprland Config:** Clean, modular configuration using Hyprland's native Lua interface.

---

## 📂 Repository Structure

```text
dots-hyprland/
├── dots/                                # System home mirror installed via GNU Stow
│   └── .config/
│       ├── hypr/                        # Hyprland configuration (Lua)
│       ├── matugen/                     # Palette templates and configs
│       └── quickshell/dots-hyprland/    # Quickshell package root
│           ├── shell.qml                # Entry point
│           ├── services/                # Backend data services (Audio, Net, Hypr, etc.)
│           └── modules/                 # Shell UI (common widgets, bar, sidebars, OSD)
├── assets/                              # Default wallpapers and fonts
├── scripts/                             # Runtime helper scripts (theming, palette sync)
├── sdata/                               # Package lists and installation metadata
├── setup                                # Entrypoint installer script
├── CHANGELOG.md                         # Version history
└── README.md
```

---

## ⌨️ Keybindings Philosophy

Keybindings in `dots-hyprland` are split into three robust levels:

1. **Level 1 (Essential):** System-critical binds mapped directly in Hyprland (Terminal, Window Management, Workspaces, Audio/Brightness keys, Session Exit). Works independently of the shell.
2. **Level 2 (Shell Integration):** Binds that trigger Quickshell widgets over IPC (`SUPER + V` for Clipboard, `SUPER + /` for Cheatsheet, Launcher, Overview, Sidebar).
3. **Level 3 (Comfort & Extra):** Advanced workspace controls, scratchpads, submaps, screen zoom, and utility modes.

---

## 🗺️ Development Roadmap

- [x] **0.0 - Autonomous Hyprland:** Independent Lua configuration, basic system keybinds, monitors, input, and fallback launcher.
- [ ] **0.1 - Quickshell Core:** Basic shell lifecycle, IPC communication, and foundational singletons (`Config`, `Appearance`, `GlobalStates`).
- [ ] **0.2 - Design System:** Material 3 UI component library (Buttons, Sliders, Toggles, Cards).
- [ ] **0.3 - Bar & Services:** Complete system status bar with PipeWire, NetworkManager, MPRIS, and Tray integration.
- [ ] **0.4 - Notifications & Control Center:** Notification daemon and quick-settings right sidebar.
- [ ] **0.5 - Dynamic Theming:** Wallpaper selection and automated theme propagation via `matugen`.
- [ ] **0.6 - Launcher & Session:** Overview, app launcher, OSD, and power menu.
- [ ] **1.0 - Stable MVP:** Fully functional daily-driver environment.

---

## 📄 License

Distributed under the **GNU General Public License v3.0** (`GPL-3.0`). See [`LICENSE`](LICENSE) for details.

*Note: Code snippets, structural designs, and components adapted from `end-4/dots-hyprland` or `iNiR` retain their respective copyright headers as documented in `docs/NOTICE.md`.*