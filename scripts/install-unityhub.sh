#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Installing Unity Hub..."

# Check if Unity Hub is already installed
if command -v unityhub >/dev/null 2>&1; then
    echo "[INFO] Unity Hub is already installed."
    exit 0
fi

# Make sure yay is available
if ! command -v yay >/dev/null 2>&1; then
    echo "[ERROR] yay is not installed. Please install yay first."
    exit 1
fi

# Try AUR first
echo "[INFO] Checking AUR for Unity Hub..."
if yay -Ss unityhub 2>/dev/null | grep -q "^aur/unityhub"; then
    echo "[INFO] Found Unity Hub in AUR, installing..."
    yay -S --noconfirm unityhub
    echo "[INFO] Unity Hub installation complete!"
    exit 0
fi

# Fallback: Download and convert .deb package
echo "[INFO] Unity Hub not found in AUR. Attempting to install from .deb package..."

# Check if debtap is installed
if ! command -v debtap >/dev/null 2>&1; then
    echo "[INFO] Installing debtap (required to convert .deb packages)..."
    yay -S --noconfirm debtap
fi

# Create temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "[INFO] Unity Hub not available in AUR. Attempting to download .deb package..."

# Try to find the latest .deb from Unity's repository
# Unity uses a repository structure, so we'll try common patterns
DEB_FOUND=false

# Try direct download from Unity's repo (this may need updating)
for url in \
    "https://hub.unity3d.com/linux/repos/deb/pool/main/u/unityhub/unityhub_amd64.deb" \
    "https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage"; do
    
    if wget -q --spider "$url" 2>/dev/null; then
        echo "[INFO] Downloading from: $url"
        if wget -q "$url" -O "$TEMP_DIR/unityhub.deb" 2>/dev/null || \
           wget -q "$url" -O "$TEMP_DIR/unityhub.AppImage" 2>/dev/null; then
            DEB_FOUND=true
            break
        fi
    fi
done

if [ "$DEB_FOUND" = false ]; then
    echo "[ERROR] Could not automatically download Unity Hub."
    echo "[INFO] Please download manually:"
    echo "       1. Go to: https://unity.com/download"
    echo "       2. Download the Linux .deb package"
    echo "       3. Run: debtap <path-to-deb>"
    echo "       4. Run: sudo pacman -U unityhub*.pkg.tar.zst"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Handle AppImage if downloaded instead
if [ -f "$TEMP_DIR/unityhub.AppImage" ]; then
    echo "[INFO] AppImage downloaded. Making executable and installing..."
    chmod +x "$TEMP_DIR/unityhub.AppImage"
    sudo mv "$TEMP_DIR/unityhub.AppImage" /usr/local/bin/unityhub
    rm -rf "$TEMP_DIR"
    echo "[INFO] Unity Hub installation complete!"
    exit 0
fi

echo "[INFO] Converting .deb to Arch package..."
# Update debtap database
sudo debtap -u 2>/dev/null || true

# Convert .deb to .pkg.tar.zst
debtap unityhub.deb

# Find the generated package
PKG_FILE=$(find . -name "unityhub*.pkg.tar.zst" | head -1)

if [ -z "$PKG_FILE" ]; then
    echo "[ERROR] Failed to convert .deb package."
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "[INFO] Installing converted package..."
sudo pacman -U --noconfirm "$PKG_FILE"

# Cleanup
cd - >/dev/null
rm -rf "$TEMP_DIR"

echo "[INFO] Unity Hub installation complete!"
echo "[INFO] Launch Unity Hub with: unityhub"

