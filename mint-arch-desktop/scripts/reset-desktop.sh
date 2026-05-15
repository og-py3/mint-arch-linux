#!/usr/bin/env bash
# =============================================================================
# Mint Arch Linux — Reset Desktop
# WARNING: Deletes the container AND all saved data. Fresh start.
# =============================================================================

RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'; NC='\033[0m'
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
ok()    { echo -e "${GREEN}[✓]${NC} $*"; }
error() { echo -e "${RED}[✗]${NC} $*"; exit 1; }

warn "This will DELETE the desktop container AND all saved files!"
read -r -p "Are you sure? Type YES to confirm: " confirm

if [ "$confirm" != "YES" ]; then
    echo "Cancelled."
    exit 0
fi

echo "Removing container..."
docker stop mint-arch-desktop 2>/dev/null || true
docker rm mint-arch-desktop 2>/dev/null || true

echo "Removing saved data..."
rm -rf /workspaces/mint-arch-data

ok "Desktop reset complete. Run start-desktop.sh for a fresh start."
