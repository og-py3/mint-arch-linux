#!/usr/bin/env bash
# =============================================================================
# Mint Arch Linux — VM Browser Desktop
# Boots the real Mint Arch Linux ISO in QEMU, served via noVNC on port 3000
# Handles split-part ISO downloads automatically (GitHub 2 GB asset limit)
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

# ── Step 1: Get the ISO ─────────────────────────────────────────────────────
if [ ! -f "$ISO_PATH" ]; then
    info "Fetching latest release info from GitHub..."
    RELEASE_DATA=$(curl -sf "https://api.github.com/repos/${REPO}/releases/latest" || true)

    # Check for split parts first (.iso.partaa, .iso.partab, ...)
    PART_URLS=$(echo "$RELEASE_DATA" | grep '"browser_download_url"' | grep '.iso.part' \
        | sed 's/.*"browser_download_url": "\(.*\)".*/\1/' | sort || true)

    if [ -n "$PART_URLS" ]; then
        TOTAL=$(echo "$PART_URLS" | wc -l)
        info "Found split ISO — downloading $TOTAL parts (~1.9 GB each)..."
        mkdir -p /vm/parts
        PART_NUM=1
        while IFS= read -r URL; do
            FNAME=$(basename "$URL")
            info "  Part $PART_NUM/$TOTAL: $FNAME"
            curl -L --progress-bar -o "/vm/parts/$FNAME" "$URL" \
                || error "Download failed: $FNAME"
            PART_NUM=$((PART_NUM + 1))
        done <<< "$PART_URLS"
        info "Reassembling ISO from $TOTAL parts..."
        cat /vm/parts/mintarch-*.iso.part* > "$ISO_PATH"
        rm -rf /vm/parts
        ok "ISO ready: $(du -sh "$ISO_PATH" | cut -f1)"
    else
        RELEASE_ISO=$(echo "$RELEASE_DATA" | grep '"browser_download_url"' | grep '.iso"' \
            | head -1 | sed 's/.*"browser_download_url": "\(.*\)".*/\1/' || true)
        if [ -n "$RELEASE_ISO" ]; then
            info "Downloading ISO: $RELEASE_ISO"
            curl -L --progress-bar -o "$ISO_PATH" "$RELEASE_ISO" || error "Download failed."
            ok "ISO ready: $(du -sh "$ISO_PATH" | cut -f1)"
        else
            error "No ISO found in GitHub releases.\nRun the Build workflow then publish a release."
        fi
    fi
else
    ok "ISO found: $(du -sh "$ISO_PATH" | cut -f1)"
fi

# ── Step 2: Create virtual disk ─────────────────────────────────────────────
if [ ! -f "$DISK_PATH" ]; then
    info "Creating ${DISK_SIZE} virtual disk..."
    qemu-img create -f qcow2 "$DISK_PATH" "$DISK_SIZE" -q
    ok "Virtual disk created at $DISK_PATH"
else
    ok "Virtual disk found: $(du -sh "$DISK_PATH" | cut -f1)"
fi

# ── Step 3: Locate OVMF (UEFI firmware) ─────────────────────────────────────
OVMF_CODE=""
for f in /usr/share/OVMF/OVMF_CODE_4M.fd /usr/share/OVMF/OVMF_CODE.fd /usr/share/qemu/OVMF.fd; do
    [ -f "$f" ] && OVMF_CODE="$f" && break
done
OVMF_VARS_SRC=""
for f in /usr/share/OVMF/OVMF_VARS_4M.fd /usr/share/OVMF/OVMF_VARS.fd; do
    [ -f "$f" ] && OVMF_VARS_SRC="$f" && break
done
OVMF_VARS="/vm/OVMF_VARS.fd"
[ -n "$OVMF_VARS_SRC" ] && [ ! -f "$OVMF_VARS" ] && cp "$OVMF_VARS_SRC" "$OVMF_VARS"

# ── Step 4: Detect KVM ──────────────────────────────────────────────────────
ACCEL_OPTS="-machine type=q35,accel=tcg -cpu qemu64"
if [ -e /dev/kvm ] && [ -r /dev/kvm ]; then
    ACCEL_OPTS="-machine type=q35,accel=kvm -cpu host -enable-kvm"
    ok "KVM hardware acceleration enabled"
else
    warn "KVM not available — using software emulation (slower)"
fi

# ── Step 5: Start noVNC ─────────────────────────────────────────────────────
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
echo -e "  ${BOLD}  Run \`sudo mint-installer\` to install to disk${NC}"
echo ""

# ── Step 6: Start QEMU ──────────────────────────────────────────────────────
info "Starting Mint Arch Linux VM..."
FIRMWARE_OPTS=""
if [ -n "$OVMF_CODE" ]; then
    FIRMWARE_OPTS="-drive if=pflash,format=raw,readonly=on,file=${OVMF_CODE}"
    [ -f "$OVMF_VARS" ] && FIRMWARE_OPTS="${FIRMWARE_OPTS} -drive if=pflash,format=raw,file=${OVMF_VARS}"
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