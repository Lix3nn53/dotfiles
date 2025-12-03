#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Installing Discord with yay..."

# Check if Discord is already installed
if command -v discord >/dev/null 2>&1; then
    echo "[INFO] Discord is already installed."
    exit 0
fi

# Make sure yay is available
if ! command -v yay >/dev/null 2>&1; then
    echo "[ERROR] yay is not installed. Please install yay first."
    exit 1
fi

# Install Discord from official Arch repos (extra repository)
yay -S --noconfirm discord

echo "[INFO] Discord installation complete!"

