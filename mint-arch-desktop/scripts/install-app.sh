#!/usr/bin/env bash
# =============================================================================
# Mint Arch Linux — App Installer
# Installs a package and saves it for automatic reinstall on next startup
# Usage: bash install-app.sh <package-name>
# =============================================================================

MINT='\033[38;2;46;203;113m'; BOLD='\033[1m'; NC='\033[0m'
GREEN='\033[0;32m'; RED='\033[0;31m'

ok()    { echo -e "${GREEN}[✓]${NC} $*"; }
error() { echo -e "${RED}[✗]${NC} $*"; exit 1; }
info()  { echo -e "${MINT}[+]${NC} $*"; }

APP="$1"
SAVED_APPS="/workspaces/mint-arch-data/saved-apps.txt"

if [ -z "$APP" ]; then
    echo "Usage: bash install-app.sh <package-name>"
    echo "Example: bash install-app.sh firefox"
    exit 1
fi

info "Installing $APP inside the desktop..."

docker exec mint-arch-desktop pacman -S --noconfirm --needed "$APP"
STATUS=$?

if [ $STATUS -eq 0 ]; then
    # Save for reinstall on next startup (avoid duplicates)
    touch "$SAVED_APPS"
    if ! grep -qx "$APP" "$SAVED_APPS"; then
        echo "$APP" >> "$SAVED_APPS"
    fi
    ok "$APP installed and saved for future sessions!"
    echo ""
    echo "  Saved apps: $(wc -l < "$SAVED_APPS") total"
    echo "  File: $SAVED_APPS"
else
    error "Failed to install $APP. Check the package name with: docker exec mint-arch-desktop pacman -Ss $APP"
fi
