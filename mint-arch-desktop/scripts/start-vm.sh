#!/usr/bin/env bash
# =============================================================================
# Mint Arch Linux — VM Browser Desktop
# Boots the real Mint Arch Linux ISO in QEMU, served via noVNC on port 3000
# =============================================================================
set -euo pipefail

ISO_PATH="${ISO_PATH:-/vm/mintarch.iso}"
DISK_PATH="/vm/mintarch-disk.qcow2"
VM_RAM="${VM_RAM:-2048}"
VM_CPUS="${VM_CPUS:-2}"
VNC_PORT="${VNC_PORT:-5900}"
NOVNC_PORT="${NOVNC_PORT:-3000}"
DISK_SIZE="${DISK_SIZE:-20G}"
REPO="og-py3/mint-arch-linux"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'

info()  { echo -e "\033[0;36m[*]${NC} $*"; }
ok()    { echo -e "${GREEN}[✓]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
error() { echo -e "${RED}[✗]${NC} $*"; exit 1; }

echo ""
echo -e "${BOLD}\033[0;36m  Mint Arch Linux — VM Browser Desktop${NC}"
echo "  ─────────────────────────────────────────────"
echo ""

# ── Step 1: Get the ISO ──────────────────────────────────────────────────────
if [ ! -f "$ISO_PATH" ]; then
    info "Searching for latest Mint Arch Linux ISO on GitHub releases..."
    RELEASE_ISO=$(curl -sf "https://api.github.com/repos/${REPO}/releases/latest" \
        | grep '"browser_download_url"' \
        | grep '\.iso' \
        | head -1 \
        | sed 's/.*"browser_download_url": "\(.*\)".*/\1/' || true)

    if [ -n "$RELEASE_ISO" ]; then
        info "Downloading ISO: $RELEASE_ISO"
        curl -L --progress-bar -o "$ISO_PATH" "$RELEASE_ISO" \
            || error "Download failed. Check your internet connection."
        ok "ISO ready: $(du -sh "$ISO_PATH" | cut -f1)"
    else
        error "No ISO found in GitHub releases.\nRun the 'Build Mint Arch Linux ISO' workflow first,\nthen publish a release at https://github.com/${REPO}/releases"
    fi
else
    ok "ISO found: $(du -sh "$ISO_PATH" | cut -f1)"
fi

# ── Step 2: Create virtual disk ──────────────────────────────────────────────
if [ ! -f "$DISK_PATH" ]; then
    info "Creating ${DISK_SIZE} virtual disk for persistent storage..."
    qemu-img create -f qcow2 "$DISK_PATH" "$DISK_SIZE" -q
    ok "Virtual disk created at $DISK_PATH"
else
    ok "Virtual disk found: $(du -sh "$DISK_PATH" | cut -f1)"
fi

# ── Step 3: Locate OVMF (UEFI firmware) ─────────────────────────────────────
OVMF_CODE=""
for f in /usr/share/OVMF/OVMF_CODE_4M.fd \
          /usr/share/OVMF/OVMF_CODE.fd \
          /usr/share/qemu/OVMF.fd; do
    if [ -f "$f" ]; then OVMF_CODE="$f"; break; fi
done

OVMF_VARS_SRC=""
for f in /usr/share/OVMF/OVMF_VARS_4M.fd \
          /usr/share/OVMF/OVMF_VARS.fd; do
    if [ -f "$f" ]; then OVMF_VARS_SRC="$f"; break; fi
done

OVMF_VARS="/vm/OVMF_VARS.fd"
if [ -n "$OVMF_VARS_SRC" ] && [ ! -f "$OVMF_VARS" ]; then
    cp "$OVMF_VARS_SRC" "$OVMF_VARS"
fi

# ── Step 4: Detect KVM ───────────────────────────────────────────────────────
ACCEL_OPTS="-machine type=q35,accel=tcg -cpu qemu64"
if [ -e /dev/kvm ] && [ -r /dev/kvm ]; then
    ACCEL_OPTS="-machine type=q35,accel=kvm -cpu host -enable-kvm"
    ok "KVM hardware acceleration enabled"
else
    warn "KVM not available — using software emulation (TCG)"
fi

# ── Step 5: Start noVNC ──────────────────────────────────────────────────────
NOVNC_WEB="/usr/share/novnc"
for d in /usr/share/novnc /usr/share/novnc/web; do
    [ -f "$d/vnc.html" ] && NOVNC_WEB="$d" && break
done

info "Starting noVNC on port ${NOVNC_PORT}..."
websockify --web "$NOVNC_WEB" "${NOVNC_PORT}" "localhost:${VNC_PORT}" &>/dev/null &
sleep 1
ok "Browser desktop ready"
echo ""
echo -e "  ${BOLD}${GREEN}Open in your browser:${NC}"
echo -e "    \033[0;36mhttp://localhost:${NOVNC_PORT}/vnc.html${NC}"
echo -e "  ${BOLD}  Login: mint / mint${NC}"
echo -e "  ${BOLD}  Run \`sudo mint-installer\` to install to the virtual disk${NC}"
echo ""

# ── Step 6: Start QEMU ───────────────────────────────────────────────────────
info "Starting Mint Arch Linux VM..."

FIRMWARE_OPTS=""
if [ -n "$OVMF_CODE" ]; then
    FIRMWARE_OPTS="-drive if=pflash,format=raw,readonly=on,file=${OVMF_CODE}"
    if [ -f "$OVMF_VARS" ]; then
        FIRMWARE_OPTS="${FIRMWARE_OPTS} -drive if=pflash,format=raw,file=${OVMF_VARS}"
    fi
fi

exec qemu-system-x86_64 \
    -name "Mint Arch Linux" \
    ${ACCEL_OPTS} \
    -m "${VM_RAM}" \
    -smp "${VM_CPUS}" \
    ${FIRMWARE_OPTS} \
    -drive "file=${ISO_PATH},media=cdrom,readonly=on,if=ide,index=0" \
    -drive "file=${DISK_PATH},format=qcow2,if=virtio,cache=writeback,index=1" \
    -boot order=d,menu=off \
    -vga virtio \
    -display "vnc=0.0.0.0:$((VNC_PORT - 5900))" \
    -device virtio-net-pci,netdev=net0 \
    -netdev "user,id=net0,hostfwd=tcp::2222-:22" \
    -device usb-ehci \
    -device usb-tablet \
    -rtc base=utc,clock=host \
    -no-reboot
