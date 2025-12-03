#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME"
ADOPT=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        --adopt) ADOPT=true ;;
    esac
done

info()  { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m $*"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $*"; }

# -----------------------------
# Stow all packages
# -----------------------------
PACKAGES_DIR="$DOTFILES_DIR/packages"
cd "$PACKAGES_DIR"

STOW_OPTS=(-R -t "$TARGET_DIR")
$ADOPT && STOW_OPTS+=(--adopt)

for pkg in */; do
    pkg=${pkg%/}
    [[ "$pkg" == "example" ]] && continue  # skip example package
    info "Stowing $pkg..."
    if ! stow "${STOW_OPTS[@]}" "$pkg"; then
        error "Failed to stow $pkg. Try: ./bootstrap.sh --adopt"
    fi
done

# -----------------------------
# Optional install scripts
# -----------------------------
SCRIPTS_DIR="$DOTFILES_DIR/scripts"
shopt -s nullglob
INSTALL_SCRIPTS=("$SCRIPTS_DIR"/*.sh)
shopt -u nullglob

if [ ${#INSTALL_SCRIPTS[@]} -gt 0 ]; then
    echo
    info "Optional install scripts:"
    select script in "${INSTALL_SCRIPTS[@]}" "Done"; do
        case $script in
            Done) break ;;
            "") warn "Invalid selection" ;;
            *)
                info "Running $(basename "$script")..."
                bash "$script"
                info "Select another or choose 'Done'"
                ;;
        esac
    done
fi

info "Dotfiles setup complete!"

