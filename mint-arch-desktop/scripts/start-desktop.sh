#!/usr/bin/env bash
# =============================================================================
# Mint Arch Linux — Local Docker Desktop Launcher
# Builds and runs the Mint Arch Linux desktop on your local machine
# Usage: bash scripts/start-desktop.sh
# =============================================================================

MINT='\033[38;2;46;203;113m'; BOLD='\033[1m'; NC='\033[0m'
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'

info()  { echo -e "${MINT}[+]${NC} $*"; }
ok()    { echo -e "${GREEN}[✓]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
error() { echo -e "${RED}[✗]${NC} $*"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
DESKTOP_DIR="$(dirname "$SCRIPT_DIR")"
DATA_DIR="$HOME/.mint-arch-data"

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

# Check Docker
docker info > /dev/null 2>&1 || error "Docker not running. Please start Docker first."
ok "Docker is ready"

mkdir -p "$DATA_DIR"

# Check if already running
if docker ps -q -f name=mint-arch-desktop | grep -q .; then
    ok "Mint Arch Linux desktop is already running!"
    echo ""
    echo -e "  Open: ${BOLD}http://localhost:3000${NC}"
    echo -e "  User: ${BOLD}mint${NC}  Password: ${BOLD}mint${NC}"
    exit 0
fi

# Resume if stopped
if docker ps -aq -f name=mint-arch-desktop | grep -q .; then
    info "Resuming existing desktop (your files are preserved)..."
    docker start mint-arch-desktop
    ok "Desktop resumed!"
else
    # Check if custom image exists, build if not
    if ! docker image inspect mint-arch-linux-desktop:latest > /dev/null 2>&1; then
        info "Building Mint Arch Linux desktop image (first time only, ~5 min)..."
        warn "This downloads Arch Linux + KDE + security tools (~3GB)"
        echo ""
        docker build -t mint-arch-linux-desktop:latest "$DESKTOP_DIR" \
            --build-arg BUILDKIT_INLINE_CACHE=1 \
            --progress=plain || {
            warn "Custom build failed, falling back to stock Arch KDE image..."
            docker pull lscr.io/linuxserver/webtop:arch-kde
            docker tag lscr.io/linuxserver/webtop:arch-kde mint-arch-linux-desktop:latest
        }
        ok "Image ready!"
    else
        ok "Using existing Mint Arch Linux image"
    fi

    info "Starting Mint Arch Linux desktop..."
    docker run -d \
        --name=mint-arch-desktop \
        -e PUID=1000 \
        -e PGID=1000 \
        -e TZ="${TZ:-UTC}" \
        -e TITLE="Mint Arch Linux" \
        -e CUSTOM_USER=mint \
        -e PASSWORD=mint \
        -p 3000:3000 \
        -v "$DATA_DIR:/config" \
        -v "$PROJECT_DIR:/workspaces/mint-arch-linux:ro" \
        --shm-size=2gb \
        --restart unless-stopped \
        mint-arch-linux-desktop:latest

    ok "Container started!"
fi

# Wait for ready
info "Waiting for desktop to be ready..."
for i in $(seq 1 30); do
    curl -s http://localhost:3000 > /dev/null 2>&1 && break
    sleep 2
    echo -n "."
done
echo ""

echo ""
echo -e "${MINT}${BOLD}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${MINT}${BOLD}║   Mint Arch Linux Desktop is ready!                 ║${NC}"
echo -e "${MINT}${BOLD}╠══════════════════════════════════════════════════════╣${NC}"
echo -e "${MINT}${BOLD}║${NC}   Browser:   ${BOLD}http://localhost:3000${NC}"
echo -e "${MINT}${BOLD}║${NC}   Username:  ${BOLD}mint${NC}"
echo -e "${MINT}${BOLD}║${NC}   Password:  ${BOLD}mint${NC}"
echo -e "${MINT}${BOLD}║${NC}   Data dir:  ${BOLD}$DATA_DIR${NC}"
echo -e "${MINT}${BOLD}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${CYAN}In the desktop terminal, run:${NC}"
echo "    sudo mint-tools-setup    — install security tools"
echo "    sudo pacman -S blackarch — install all 2800+ tools"
echo "    fastfetch                — system info"
echo ""
