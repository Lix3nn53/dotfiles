# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) for [Omarchy](https://omarchy.org/). Omarchy comes with Arch Linux, Hyprland, and yay.

## Quick Start

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

If files already exist, use `--adopt` to pull them into dotfiles:
```bash
./bootstrap.sh --adopt
```

After editing files in `packages/`, run `./bootstrap.sh` again. Note: Editing existing files applies changes immediately (symlinks). Re-run bootstrap when adding/removing files or changing directory structure.

## Prerequisites

- [Omarchy](https://omarchy.org/)
- [GNU Stow](https://www.gnu.org/software/stow/) - `sudo pacman -S stow`

Note: yay comes with Omarchy, so no need to install it separately.

## Packages

### Hyprland (`packages/hypr/`)

Window manager configuration:
- Monitor setup (dual monitor configuration)
- `GDK_SCALE=2` for high-DPI displays

**Location:** `~/.config/hypr/`

### Unity Hub (`packages/unityhub/`)

Unity Hub wrapper with UI scaling fixes:
- Sets `GDK_SCALE=1` and `GDK_DPI_SCALE=0.5` for Unity Editor
- Overrides global `GDK_SCALE=2` from Hyprland

**Locations:**
- `~/.local/bin/unityhub` - Wrapper script
- `~/.local/share/applications/unityhub.desktop` - Desktop file

### Systemd (`packages/systemd/`)

DNS configuration for systemd-resolved:
- Cloudflare DNS (1.1.1.1, 1.0.0.1)
- Fallback DNS (Quad9, Cloudflare, Google)

**Note:** Requires `sudo`. Use `scripts/apply-systemd-dns.sh`

**Location:** `/etc/systemd/resolved.conf` (managed via script)

## Scripts

### Application Installers

- `install-firefox.sh` - Installs Firefox and sets as default browser
- `install-discord.sh` - Installs Discord from official Arch repos
- `install-cursor.sh` - Installs Cursor editor from AUR
- `install-warp.sh` - Installs Cloudflare WARP and sets up connection
- `install-unityhub.sh` - Installs Unity Hub (AUR or .deb conversion)
- `install-speech-dispatcher.sh` - Installs Speech Dispatcher for Firefox

### Configuration Scripts

- `apply-systemd-dns.sh` - Applies DNS configuration to systemd-resolved

## Omarchy Notes

Bluetooth TUI: https://github.com/pythops/bluetui

## License

Personal dotfiles - use as you wish.
