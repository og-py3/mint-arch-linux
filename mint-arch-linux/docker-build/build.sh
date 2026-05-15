#!/usr/bin/env bash
# =============================================================================
# Mint Arch Linux — Docker ISO Builder  |  Run this on Windows / Mac / Linux
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="${PROJECT_ROOT}/output"
IMAGE_NAME="mintarch-builder"
CHANNEL="${CHANNEL:-stable}"

MINT='\033[38;2;46;203;113m'; BOLD='\033[1m'; NC='\033[0m'
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'

info()  { echo -e "${MINT}[+]${NC} $*"; }
ok()    { echo -e "${GREEN}[✓]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
error() { echo -e "${RED}[✗]${NC} $*"; exit 1; }

echo -e "${MINT}${BOLD}"
echo "  ╔══════════════════════════════════════════════╗"
echo "  ║   Mint Arch Linux Docker ISO Builder         ║"
echo "  ║   Channel: ${CHANNEL^^}                           ║"
echo "  ╚══════════════════════════════════════════════╝${NC}"
echo ""

# Check Docker is running
command -v docker &>/dev/null || error "Docker not found. Install from https://docs.docker.com/get-docker/"
docker info &>/dev/null        || error "Docker daemon not running. Start Docker Desktop first."

mkdir -p "$OUTPUT_DIR"
info "Output directory: $OUTPUT_DIR"
info "This will take 20-60 minutes depending on internet speed..."
echo ""

# Build Docker image
info "Building Docker image (downloads ~2GB of Arch packages)..."
docker build \
    --no-cache \
    --tag "$IMAGE_NAME:latest" \
    --file "$SCRIPT_DIR/Dockerfile" \
    "$PROJECT_ROOT"

ok "Docker image built: $IMAGE_NAME"

# Run the builder
info "Building Mint Arch Linux ISO..."
docker run \
    --rm \
    --privileged \
    --env CHANNEL="$CHANNEL" \
    --volume "$OUTPUT_DIR:/output" \
    "$IMAGE_NAME:latest"

# Check output
if ls "$OUTPUT_DIR"/mintarch-*.iso &>/dev/null 2>&1; then
    ISO=$(ls -t "$OUTPUT_DIR"/mintarch-*.iso | head -1)
    SIZE=$(du -sh "$ISO" | cut -f1)
    echo ""
    echo -e "${MINT}${BOLD}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${MINT}${BOLD}║  Build Successful!                           ║${NC}"
    echo -e "${MINT}${BOLD}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ISO:  ${BOLD}$(basename "$ISO")${NC}"
    echo -e "  Size: ${BOLD}${SIZE}${NC}"
    echo -e "  Path: ${BOLD}${OUTPUT_DIR}${NC}"
    echo ""
    echo "  Flash to USB:"
    echo "    Linux:   sudo dd if='$ISO' of=/dev/sdX bs=4M status=progress"
    echo "    Windows: Use Rufus or Ventoy"
    echo "    Mac:     Use balenaEtcher"
    echo ""
    echo "  VirtualBox:"
    echo "    New VM → Arch Linux 64-bit → Enable EFI → Attach ISO → Boot"
    echo "    Login: mint / mint → sudo mint-installer"
    echo ""
else
    error "Build failed — no ISO found in $OUTPUT_DIR"
fi
