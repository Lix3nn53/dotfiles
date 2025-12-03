#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Installing Cloudflare WARP with yay..."

# Check if WARP is already installed
if command -v warp-cli >/dev/null 2>&1; then
    echo "[INFO] WARP is already installed."
else
    # Make sure yay is available
    if ! command -v yay >/dev/null 2>&1; then
        echo "[ERROR] yay is not installed. Please install yay first."
        exit 1
    fi

    # Install WARP via AUR
    yay -S --noconfirm cloudflare-warp-bin
    echo "[INFO] WARP installed."
fi

echo "[INFO] Enabling and starting WARP service..."
sudo systemctl enable --now warp-svc

echo "[INFO] Waiting for service to start..."
sleep 3

# Check if already registered
if warp-cli account 2>/dev/null | grep -q "Account type"; then
    echo "[INFO] WARP is already registered."
else
    echo "[INFO] Registering WARP client..."
    warp-cli registration new
fi

echo "[INFO] Connecting to WARP..."
warp-cli connect

echo "[INFO] Verifying connection..."
sleep 2
if curl -s https://www.cloudflare.com/cdn-cgi/trace/ | grep -q "warp=on"; then
    echo "[INFO] ✓ WARP is connected! (warp=on)"
else
    echo "[WARN] WARP connection verification failed. Check status with: warp-cli status"
fi

echo "[INFO] WARP setup complete!"

