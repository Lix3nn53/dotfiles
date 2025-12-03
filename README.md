# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) for Arch Linux with Hyprland (Omarchy).

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

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the bootstrap script:**
   ```bash
   ./bootstrap.sh
   ```

3. **If files already exist, use `--adopt` to pull them into dotfiles:**
   ```bash
   ./bootstrap.sh --adopt
   ```

## Structure

```
dotfiles/
├── bootstrap.sh              # Main setup script
├── packages/                  # Stow packages
│   ├── hypr/                  # Hyprland configuration
│   ├── unityhub/              # Unity Hub wrapper with UI scaling
│   ├── systemd/               # Systemd DNS configuration
│   └── example/               # Example package (skipped by default)
└── scripts/                   # Installation scripts
    ├── install-*.sh           # Application installers
    └── apply-systemd-dns.sh   # DNS configuration script
```

## Packages

### Hyprland (`packages/hypr/`)

Hyprland window manager configuration:
- `monitors.conf` - Monitor setup (dual monitor configuration)
- `GDK_SCALE=2` for high-DPI displays

**Location:** `~/.config/hypr/monitors.conf`

### Unity Hub (`packages/unityhub/`)

Unity Hub wrapper with UI scaling fixes for Linux:
- Wrapper script that sets `GDK_SCALE=1` and `GDK_DPI_SCALE=0.5` for Unity Editor
- Overrides global `GDK_SCALE=2` from Hyprland monitors.conf
- Desktop file override

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

All scripts are optional and can be run from `bootstrap.sh` or directly:

### Application Installers

- **`install-firefox.sh`** - Installs Firefox and sets as default browser
- **`install-discord.sh`** - Installs Discord from official Arch repos
- **`install-cursor.sh`** - Installs Cursor editor from AUR
- **`install-warp.sh`** - Installs Cloudflare WARP and sets up connection
- **`install-unityhub.sh`** - Installs Unity Hub (AUR or .deb conversion)

### Configuration Scripts

- **`apply-systemd-dns.sh`** - Applies DNS configuration to systemd-resolved

## Usage

### Applying Changes

After editing files in `packages/`, run:
```bash
./bootstrap.sh
```

**Note:** If you only edit existing files, changes apply immediately (symlinks). You only need to re-run bootstrap when:
- Adding new files
- Removing files
- Changing directory structure

### Adding a New Package

1. Create package directory:
   ```bash
   mkdir -p packages/myapp/.config/myapp
   ```

2. Add your config files:
   ```bash
   cp ~/.config/myapp/config packages/myapp/.config/myapp/
   ```

3. Run bootstrap:
   ```bash
   ./bootstrap.sh
   ```

### Removing a Package

```bash
stow -D myapp -t ~
rm -rf packages/myapp
```

## Troubleshooting

### Stow Conflicts

If stow reports conflicts (files already exist):
```bash
./bootstrap.sh --adopt
```

This pulls existing files into your dotfiles repo.

### Unity Hub UI Scaling

If Unity Editor UI is still too big:
1. Check that wrapper is being used: `which unityhub` should show `~/.local/bin/unityhub`
2. Adjust `GDK_SCALE` in `packages/unityhub/.local/bin/unityhub`
3. Check Unity Editor's internal UI scale: **Edit → Preferences → General → UI Scale**

### Monitor Configuration

To change monitor positions:
1. Edit `packages/hypr/.config/hypr/monitors.conf`
2. Run `./bootstrap.sh`
3. Reload: `hyprctl reload` or `hyprctl dispatch exit` (full restart)

### DNS Configuration

To apply DNS settings:
```bash
./scripts/apply-systemd-dns.sh
```

Requires `sudo`. The script backs up your current config automatically.

## Customization

### Changing DNS Servers

Edit `packages/systemd/.etc/systemd/resolved.conf` and run `apply-systemd-dns.sh`.

### Adjusting Unity Scaling

Edit `packages/unityhub/.local/bin/unityhub`:
- `GDK_SCALE=1` - Normal size (try 1, 2, 3 for integer scales)
- `GDK_DPI_SCALE=0.5` - DPI scaling (try 0.5, 1.0, 1.5)

### Monitor Setup

Edit `packages/hypr/.config/hypr/monitors.conf`:
```ini
monitor = DP-2,1920x1080@60,0x0,auto    # Left monitor
monitor = DP-3,1920x1080@143.98,1920x0,auto  # Right monitor
```

Format: `monitor = [port], resolution@refresh, position, scale`

## Notes

- The `example/` package is skipped by default in bootstrap.sh
- All packages use GNU Stow for symlink management
- Install scripts require `yay` for AUR packages
- Some scripts require `sudo` (noted in script comments)

## License

Personal dotfiles - use as you wish.

