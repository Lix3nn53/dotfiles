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
    while true; do
        echo
        info "Optional install scripts:"
        echo
        # Display scripts with numbers
        for i in "${!INSTALL_SCRIPTS[@]}"; do
            printf "  %d) %s\n" $((i+1)) "$(basename "${INSTALL_SCRIPTS[$i]}")"
        done
        echo "  q) Quit"
        echo
        read -p "Select a script (1-${#INSTALL_SCRIPTS[@]}, q to quit): " choice
        
        case $choice in
            [qQ])
                info "Skipping remaining install scripts."
                break
                ;;
            [1-9]|[1-9][0-9])
                idx=$((choice-1))
                if [ $idx -ge 0 ] && [ $idx -lt ${#INSTALL_SCRIPTS[@]} ]; then
                    script="${INSTALL_SCRIPTS[$idx]}"
                    info "Running $(basename "$script")..."
                    bash "$script"
                    echo
                    info "Script completed. Select another or press 'q' to quit."
                else
                    warn "Invalid selection. Please choose 1-${#INSTALL_SCRIPTS[@]} or 'q'."
                fi
                ;;
            *)
                warn "Invalid input. Please enter a number (1-${#INSTALL_SCRIPTS[@]}) or 'q' to quit."
                ;;
        esac
    done
fi

info "Dotfiles setup complete!"

