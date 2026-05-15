#!/usr/bin/env bash
# =============================================================================
# Mint Arch Linux — Stop Desktop
# Stops the desktop container (data is preserved)
# =============================================================================

MINT='\033[38;2;46;203;113m'; NC='\033[0m'; GREEN='\033[0;32m'
ok()   { echo -e "${GREEN}[✓]${NC} $*"; }
info() { echo -e "${MINT}[+]${NC} $*"; }

info "Stopping Mint Arch Linux desktop..."
docker stop mint-arch-desktop 2>/dev/null && ok "Desktop stopped. Your files are preserved." || echo "Container not running."
