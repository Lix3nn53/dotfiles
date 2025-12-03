#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Installing Cursor (cursor-bin) with yay..."

# Check if Cursor is already installed
if command -v cursor >/dev/null 2>&1; then
    echo "[INFO] Cursor is already installed."
    exit 0
fi

# Make sure yay is available
if ! command -v yay >/dev/null 2>&1; then
    echo "[ERROR] yay is not installed. Please install yay first."
    exit 1
fi

# Install Cursor via AUR
yay -S --noconfirm cursor-bin

echo "[INFO] Cursor installation complete!"

