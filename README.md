# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) for Arch Linux with Hyprland. This is for [Omarchy](https://omarchy.org/).

## Overview

This repository contains configuration files and installation scripts for:
- **Hyprland** - Window manager configuration
- **Unity Hub/Editor** - Unity development tools with UI scaling fixes
- **Systemd** - DNS configuration (Cloudflare)
- **Installation scripts** - Automated setup for common applications

## Prerequisites

- Arch Linux (or Arch-based distribution)
- [GNU Stow](https://www.gnu.org/software/stow/) - `sudo pacman -S stow`
- [yay](https://github.com/Jguer/yay) - AUR helper (for install scripts)

## Quick Start

1. Clone the repository:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. Run the bootstrap script:
   ```bash
   ./bootstrap.sh
   ```

3. If files already exist, use `--adopt`:
   ```bash
   ./bootstrap.sh --adopt
   ```

## Packages

### Hyprland (`packages/hypr/`)

Hyprland window manager configuration:
- Monitor setup (dual monitor configuration)
- `GDK_SCALE=2` for high-DPI displays

**Location:** `~/.config/hypr/`

### Unity Hub (`packages/unityhub/`)

Unity Hub wrapper with UI scaling fixes:
- Wrapper script that sets `GDK_SCALE=1` and `GDK_DPI_SCALE=0.5` for Unity Editor
- Overrides global `GDK_SCALE=2` from Hyprland

**Locations:**
- `~/.local/bin/unityhub` - Wrapper script
- `~/.local/share/applications/unityhub.desktop` - Desktop file

### Systemd (`packages/systemd/`)

DNS configuration for systemd-resolved:
- Cloudflare DNS (1.1.1.1, 1.0.0.1)
- Fallback DNS (Quad9, Cloudflare, Google)

**Note:** Requires `sudo` to apply. Use `scripts/apply-systemd-dns.sh`

**Location:** `/etc/systemd/resolved.conf` (managed via script)

## Installation Scripts

### Application Installers

- `install-firefox.sh` - Installs Firefox and sets as default browser
- `install-discord.sh` - Installs Discord from official Arch repos
- `install-cursor.sh` - Installs Cursor editor from AUR
- `install-warp.sh` - Installs Cloudflare WARP and sets up connection
- `install-unityhub.sh` - Installs Unity Hub (AUR or .deb conversion)
- `install-speech-dispatcher.sh` - Installs Speech Dispatcher for Firefox

### Configuration Scripts

- `apply-systemd-dns.sh` - Applies DNS configuration to systemd-resolved

## Omarchy

Bluetooth TUI is https://github.com/pythops/bluetui

## Usage

After editing files in `packages/`, run:
```bash
./bootstrap.sh
```

**Note:** If you only edit existing files, changes apply immediately (symlinks). Re-run bootstrap when adding/removing files or changing directory structure.

## License

Personal dotfiles - use as you wish.
