#!/usr/bin/env bash
# =============================================================================
# Mint Arch Linux — Codespaces Init Script
# Runs after the devcontainer starts — sets up branding and welcome screen
# =============================================================================

MINT='\033[38;2;46;203;113m'
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

clear
echo -e "${MINT}${BOLD}"
cat << 'ASCII'
  ███╗   ███╗██╗███╗   ██╗████████╗      █████╗ ██████╗  ██████╗██╗  ██╗
  ████╗ ████║██║████╗  ██║╚══██╔══╝     ██╔══██╗██╔══██╗██╔════╝██║  ██║
  ██╔████╔██║██║██╔██╗ ██║   ██║        ███████║██████╔╝██║     ███████║
  ██║╚██╔╝██║██║██║╚██╗██║   ██║        ██╔══██║██╔══██╗██║     ██╔══██║
  ██║ ╚═╝ ██║██║██║ ╚████║   ██║        ██║  ██║██║  ██║╚██████╗██║  ██║
  ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝        ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
ASCII
echo -e "${NC}"
echo -e "  ${BOLD}${CYAN}Mint Arch Linux — Browser Desktop${NC}"
echo "  ────────────────────────────────────────────────────"
echo ""
echo -e "  ${GREEN}[✓] Mint Arch Linux desktop is running${NC}"
echo -e "  ${GREEN}[✓] KDE Plasma 6 ready on port 3000${NC}"
echo -e "  ${GREEN}[✓] BlackArch repository enabled (2800+ tools)${NC}"
echo ""
echo -e "  ${BOLD}Access your desktop:${NC}"
echo "    → Click 'Open in Browser' in the Ports tab"
echo "    → Or open: http://localhost:3000"
echo ""
echo -e "  ${BOLD}Login:${NC} mint / mint"
echo ""
echo -e "  ${BOLD}Quick commands (run in the KDE terminal):${NC}"
echo "    sudo mint-tools-setup          — install security tools (2800+)"
echo "    sudo pacman -S blackarch        — install ALL BlackArch tools"
echo "    fastfetch                       — system info"
echo "    sudo mint-update               — update everything"
echo ""
echo -e "  ${CYAN}────────────────────────────────────────────────────${NC}"
echo ""

# Apply os-release branding
cat > /etc/os-release << 'EOF'
NAME="Mint Arch Linux"
PRETTY_NAME="Mint Arch Linux"
ID=arch
ID_LIKE=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;46;203;113"
HOME_URL="https://github.com/og-py3/mint-arch-linux"
DOCUMENTATION_URL="https://github.com/og-py3/mint-arch-linux/blob/main/USAGE.txt"
SUPPORT_URL="https://github.com/og-py3/mint-arch-linux/issues"
BUG_REPORT_URL="https://github.com/og-py3/mint-arch-linux/issues"
LOGO="mintarch"
EOF

# Update MOTD
cat > /etc/motd << 'EOF'

  ╔══════════════════════════════════════════════╗
  ║   Mint Arch Linux — Browser Desktop          ║
  ║   KDE Plasma 6 · BlackArch · 2800+ Tools     ║
  ╠══════════════════════════════════════════════╣
  ║  sudo mint-tools-setup   install sec tools   ║
  ║  sudo mint-update        update system       ║
  ║  fastfetch               system info         ║
  ╚══════════════════════════════════════════════╝

EOF

echo -e "${GREEN}[✓] Mint Arch Linux ready. Open http://localhost:3000${NC}"
