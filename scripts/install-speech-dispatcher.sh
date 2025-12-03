#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Installing Speech Dispatcher for Firefox SpeechSynthesis API..."

# Check if Speech Dispatcher is already installed
if command -v spd-say >/dev/null 2>&1; then
    echo "[INFO] Speech Dispatcher is already installed."
    
    # Test if it works
    echo "[INFO] Testing Speech Dispatcher..."
    if spd-say "test" 2>/dev/null; then
        echo "[INFO] Speech Dispatcher is working correctly."
        exit 0
    else
        echo "[WARN] Speech Dispatcher installed but may not be working. Check configuration."
    fi
else
    # Install Speech Dispatcher from official repos
    if command -v pacman >/dev/null 2>&1; then
        echo "[INFO] Installing speech-dispatcher with pacman..."
        sudo pacman -S --noconfirm speech-dispatcher
    elif command -v yay >/dev/null 2>&1; then
        echo "[INFO] Installing speech-dispatcher with yay..."
        yay -S --noconfirm speech-dispatcher
    else
        echo "[ERROR] No package manager found (pacman/yay)."
        exit 1
    fi
    
    echo "[INFO] Speech Dispatcher installed."
fi

# Test the installation
echo "[INFO] Testing Speech Dispatcher (you should hear 'hi' spoken)..."
if spd-say "hi" 2>/dev/null; then
    echo "[INFO] Speech Dispatcher test successful!"
else
    echo "[WARN] Speech Dispatcher test failed. You may need to:"
    echo "       1. Check that speech-dispatcher service is running"
    echo "       2. Install voice packages (e.g., espeak-ng)"
    echo "       3. Check configuration in /etc/speech-dispatcher/"
fi

echo "[INFO] Speech Dispatcher setup complete!"
echo "[INFO] Note: Firefox requires Speech Dispatcher v0.8.2 or higher for SpeechSynthesis API."

