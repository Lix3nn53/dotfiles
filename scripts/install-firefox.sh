#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Installing Firefox with yay..."

if ! command -v firefox >/dev/null 2>&1; then
    if ! command -v yay >/dev/null 2>&1; then
        echo "[ERROR] yay is not installed. Please install yay first."
        exit 1
    fi
    yay -S --noconfirm firefox
    echo "[INFO] Firefox installed."
else
    echo "[INFO] Firefox is already installed."
fi

echo "[INFO] Setting Firefox as default browser..."
# xdg-settings requires BROWSER to be unset (unset it just for this command)
env -u BROWSER xdg-settings set default-web-browser firefox.desktop

echo "[INFO] Firefox setup complete!"

