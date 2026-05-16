#!/usr/bin/env bash
# =============================================================================
# Mint Arch Linux — ISO Build Script
# Usage: sudo ./build.sh [--clean] [--output /path/to/output] [--channel stable|beta|nightly]
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'
MINT='\033[38;2;46;203;113m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_DIR="$SCRIPT_DIR"
WORK_DIR="/tmp/mintarch-build"
OUT_DIR="${OUT_DIR:-$SCRIPT_DIR/output}"
PKG_LISTS_DIR="$PROFILE_DIR/packages.x86_64"
CHANNEL="${CHANNEL:-stable}"
CI="${CI:-false}"
LOG_DIR="${SCRIPT_DIR}/build-logs"
mkdir -p "$LOG_DIR"
BUILD_LOG="${LOG_DIR}/build-$(date +%Y%m%d-%H%M%S).log"

info()    { echo -e "${MINT}[+]${NC} $*" | tee -a "$BUILD_LOG"; }
warn()    { echo -e "${YELLOW}[!]${NC} $*" | tee -a "$BUILD_LOG"; }
error()   { echo -e "${RED}[✗]${NC} $*" | tee -a "$BUILD_LOG"; exit 1; }
ok()      { echo -e "${GREEN}[✓]${NC} $*" | tee -a "$BUILD_LOG"; }
section() { echo -e "\n${BOLD}${CYAN}════ $* ════${NC}\n" | tee -a "$BUILD_LOG"; }

banner() {
    echo -e "${CYAN}"
    echo "  ███╗   ███╗██╗███╗   ██╗████████╗      █████╗ ██████╗  ██████╗██╗  ██╗"
    echo "  ████╗ ████║██║████╗  ██║╚══██╔══╝     ██╔══██╗██╔══██╗██╔════╝██║  ██║"
    echo "  ██╔████╔██║██║██╔██╗ ██║   ██║        ███████║██████╔╝██║     ███████║"
    echo "  ██║╚██╔╝██║██║██║╚██╗██║   ██║        ██╔══██║██╔══██╗██║     ██╔══██║"
    echo "  ██║ ╚═╝ ██║██║██║ ╚████║   ██║        ██║  ██║██║  ██║╚██████╗██║  ██║"
    echo "  ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝        ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝"
    echo -e "${NC}"
    echo -e "  ${BOLD}Mint Arch Linux ISO Builder${NC}"
    echo "  Rolling Linux — Security Tools + KDE Plasma 6"
    echo "  ──────────────────────────────────────────────"
    echo ""
}

check_requirements() {
    section "Preflight Checks"
    [[ "$EUID" -eq 0 ]] || error "Must run as root: sudo ./build.sh"
    command -v mkarchiso &>/dev/null || error "archiso not installed. Run: pacman -S archiso"
    if [[ "$CI" != "true" ]]; then
        for cmd in parted mkfs.fat mkfs.ext4 grub-install; do
            command -v "$cmd" &>/dev/null || warn "Optional tool not found: $cmd (not needed for ISO build)"
        done
    fi
    local free_space
    free_space=$(df /tmp --output=avail -BG | tail -1 | tr -d 'G')
    (( free_space >= 15 )) || warn "Low disk space: ${free_space}GB (15GB recommended)"
    ok "All checks passed."
}

# Combine all package list txt files into a single packages.x86_64 file
# archiso expects packages.x86_64 to be a flat file at the profile root.
# Our source is organized into packages.x86_64/*.txt for readability.
combine_packages() {
    section "Combining Package Lists"
    local combined_file="$1"
    : > "$combined_file"
    for pkgfile in "$PKG_LISTS_DIR"/*.txt; do
        info "  Adding: $(basename "$pkgfile")"
        grep -v '^\s*#' "$pkgfile" | grep -v '^\s*$' >> "$combined_file"
    done
    sort -u "$combined_file" -o "$combined_file"
    local count
    count=$(wc -l < "$combined_file")
    ok "Total unique packages: $count"
}

clean_build() {
    section "Cleaning Previous Build"
    info "Removing work directory: $WORK_DIR"
    rm -rf "$WORK_DIR"
    ok "Clean done."
}

setup_blackarch_keyring() {
    section "Setting Up BlackArch Keyring"
    info "Adding BlackArch signing key..."
    pacman-key --recv-keys 4345771566D76038C7FEB43863EC0ADBEA87E4E3 2>/dev/null || \
        pacman-key --keyserver keyserver.ubuntu.com \
            --recv-keys 4345771566D76038C7FEB43863EC0ADBEA87E4E3
    pacman-key --lsign-key 4345771566D76038C7FEB43863EC0ADBEA87E4E3
    pacman -Sy --noconfirm blackarch-keyring 2>/dev/null || true
    ok "BlackArch keyring ready"
}

build_iso() {
    section "Building ISO"
    mkdir -p "$OUT_DIR"

    # Create a temp profile directory where packages.x86_64 is a file (not a dir).
    # archiso requires packages.x86_64 to be a flat package list file.
    local build_profile="/tmp/mintarch-profile"
    rm -rf "$build_profile"
    cp -r "$PROFILE_DIR" "$build_profile"

    # Replace the packages.x86_64 directory with the combined flat file
    rm -rf "$build_profile/packages.x86_64"
    combine_packages "$build_profile/packages.x86_64"

    info "Profile:  $build_profile"
    info "Output:   $OUT_DIR"
    info "Work dir: $WORK_DIR"
    echo ""

    mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$build_profile"

    local iso_file
    iso_file=$(ls -t "$OUT_DIR"/mintarch-*.iso 2>/dev/null | head -1)

    if [ -f "$iso_file" ]; then
        local size
        size=$(du -sh "$iso_file" | cut -f1)
        echo ""
        echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║  BUILD SUCCESSFUL!                           ║${NC}"
        echo -e "${GREEN}╠══════════════════════════════════════════════╣${NC}"
        echo -e "${GREEN}║${NC}  ISO:  $(basename "$iso_file")"
        echo -e "${GREEN}║${NC}  Size: $size"
        echo -e "${GREEN}║${NC}  Path: $OUT_DIR"
        echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "  ${BOLD}Flash to USB (Linux):${NC}"
        echo "  sudo dd if=$iso_file of=/dev/sdX bs=4M status=progress oflag=sync"
        echo ""
        echo -e "  ${BOLD}Or use balenaEtcher / Rufus / Ventoy${NC}"
    else
        error "ISO build failed — no output file found in $OUT_DIR"
    fi
}

generate_checksum() {
    section "Generating Checksums"
    local iso_file
    iso_file=$(ls -t "$OUT_DIR"/mintarch-*.iso 2>/dev/null | head -1)
    if [ -f "$iso_file" ]; then
        sha256sum "$iso_file" > "$iso_file.sha256"
        md5sum    "$iso_file" > "$iso_file.md5"
        ok "SHA256: $(cat "$iso_file.sha256" | cut -d' ' -f1)"
        ok "MD5:    $(cat "$iso_file.md5" | cut -d' ' -f1)"
    fi
}

CLEAN=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        --clean|-c)  CLEAN=true ;;
        --output|-o) OUT_DIR="$2"; shift ;;
        --ci)        CI=true ;;
        --help|-h)   echo "Usage: sudo ./build.sh [--clean] [--output /path] [--ci]"; exit 0 ;;
        *) warn "Unknown argument: $1" ;;
    esac
    shift
done

main() {
    banner
    check_requirements
    $CLEAN && clean_build
    setup_blackarch_keyring
    build_iso
    generate_checksum
    echo -e "\n${GREEN}${BOLD}Mint Arch Linux build complete!${NC}\n"
}

main "$@"
