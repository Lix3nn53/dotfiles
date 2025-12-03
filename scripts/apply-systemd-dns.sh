#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESOLVED_CONF="$DOTFILES_DIR/packages/systemd/.etc/systemd/resolved.conf"
TARGET="/etc/systemd/resolved.conf"

info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*"; }

if [ ! -f "$RESOLVED_CONF" ]; then
    error "Config file not found: $RESOLVED_CONF"
    exit 1
fi

info "Backing up current resolved.conf..."
sudo cp "$TARGET" "${TARGET}.bak.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true

info "Applying DNS configuration..."
sudo cp "$RESOLVED_CONF" "$TARGET"

info "Restarting systemd-resolved..."
sudo systemctl restart systemd-resolved

info "DNS configuration applied! Current DNS servers:"
resolvectl status | grep -A5 "DNS Servers" || resolvectl status

