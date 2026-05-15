#!/usr/bin/env bash
# =============================================================================
# Mint Arch Linux — Desktop Launcher
# Starts the browser-accessible KDE desktop on port 3000
# =============================================================================

MINT='\033[38;2;46;203;113m'; BOLD='\033[1m'; NC='\033[0m'
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'
CYAN='\033[0;36m'

info()  { echo -e "${MINT}[+]${NC} $*"; }
ok()    { echo -e "${GREEN}[✓]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
error() { echo -e "${RED}[✗]${NC} $*"; }

clear
echo -e "${MINT}${BOLD}"
cat << 'ASCII'
  ███╗   ███╗██╗███╗   ██╗████████╗      █████╗ ██████╗  ██████╗██╗  ██╗
  ████╗ ████║██║████╗  ██║╚══██╔══╝     ██╔══██╗██╔══██╗██╔════╝██║  ██║
  ██╔████╔██║██║██╔██╗ ██║   ██║        ███████║██████╔╝██║     ███████║
  ██║╚██╔╝██║██║██║╚██╗██║   ██║        ██╔══██║██╔══██╗██║     ██╔══██║
  ██║ ╚═╝ ██║██║██║ ╚████║   ██║        ██║  ██║██║  ██║╚██████╗██║  ██║
  ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝        ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
                                                            L I N U X
ASCII
echo -e "${NC}"
echo -e "  ${BOLD}Desktop Launcher — Browser-accessible KDE on port 3000${NC}"
echo -e "  ${CYAN}──────────────────────────────────────────────────────${NC}"
echo ""

# Wait for Docker
info "Waiting for Docker..."
until docker info > /dev/null 2>&1; do
    echo -n "."
    sleep 2
done
ok "Docker is ready!"

# Create persistent data directory
DESKTOP_DATA="/workspaces/mint-arch-data"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
mkdir -p "$DESKTOP_DATA"

# Start or resume desktop container
if [ "$(docker ps -aq -f name=mint-arch-desktop)" ]; then
    RUNNING=$(docker ps -q -f name=mint-arch-desktop)
    if [ -n "$RUNNING" ]; then
        ok "Desktop already running — open http://localhost:3000"
    else
        info "Resuming existing desktop (your files are preserved)..."
        docker start mint-arch-desktop
        ok "Desktop resumed!"
    fi
else
    info "Creating Mint Arch Linux desktop container..."
    echo ""
    warn "First run downloads ~2GB — this takes a few minutes..."
    echo ""

    docker run -d \
        --name=mint-arch-desktop \
        -e PUID=1000 \
        -e PGID=1000 \
        -e TZ="${TZ:-UTC}" \
        -e TITLE="Mint Arch Linux" \
        -e CUSTOM_USER=mint \
        -e PASSWORD=mint \
        -p 3000:3000 \
        -v "$DESKTOP_DATA:/config" \
        -v "$PROJECT_DIR:/workspaces/mint-arch-linux:ro" \
        --shm-size=2gb \
        --restart unless-stopped \
        lscr.io/linuxserver/webtop:arch-kde

    ok "Container created!"
fi

# Wait for desktop to be ready
info "Waiting for desktop to be ready..."
sleep 5
MAX_WAIT=60
COUNT=0
while ! curl -s http://localhost:3000 > /dev/null 2>&1; do
    sleep 2
    COUNT=$((COUNT + 2))
    if [ $COUNT -ge $MAX_WAIT ]; then
        warn "Desktop is taking longer than usual — it may still be starting."
        break
    fi
done

# Apply Mint Arch Linux customizations inside the container
info "Applying Mint Arch Linux customizations..."
docker exec mint-arch-desktop bash -c "
    # Install Mint Arch Linux tools if not already there
    if [ ! -f /usr/local/bin/mint-update ]; then
        echo 'Installing mint-* tools...'
        pacman -Sy --noconfirm zsh zsh-autosuggestions zsh-syntax-highlighting starship fastfetch btop neovim 2>/dev/null || true
    fi

    # Set branding in MOTD
    cat > /etc/motd << 'MOTD'

  Mint Arch Linux — Browser Desktop (KDE Plasma)
  Type mint-tools-setup to install security tools
  Type fastfetch to see system info

MOTD

    echo 'Customizations applied.'
" 2>/dev/null || true

# Reinstall saved apps from previous sessions
SAVED_APPS="$DESKTOP_DATA/saved-apps.txt"
if [ -f "$SAVED_APPS" ] && [ -s "$SAVED_APPS" ]; then
    info "Reinstalling saved apps from last session..."
    while IFS= read -r app; do
        docker exec mint-arch-desktop pacman -S --noconfirm --needed "$app" 2>/dev/null || true
        echo "  Reinstalled: $app"
    done < "$SAVED_APPS"
    ok "Saved apps restored."
fi

echo ""
echo -e "${MINT}${BOLD}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${MINT}${BOLD}║  Mint Arch Linux Desktop is ready!                  ║${NC}"
echo -e "${MINT}${BOLD}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${MINT}${BOLD}║${NC}  Open in browser:  ${BOLD}http://localhost:3000${NC}"
echo -e "${MINT}${BOLD}║${NC}  Username:         ${BOLD}mint${NC}"
echo -e "${MINT}${BOLD}║${NC}  Password:         ${BOLD}mint${NC}"
echo -e "${MINT}${BOLD}║${NC}  Your files:       ${BOLD}$DESKTOP_DATA${NC}"
echo -e "${MINT}${BOLD}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${CYAN}Useful commands in the desktop terminal:${NC}"
echo "    fastfetch              — system info"
echo "    sudo pacman -S <pkg>   — install packages"
echo "    bash /workspaces/mint-arch-linux/scripts/install-app.sh <pkg>"
echo ""
