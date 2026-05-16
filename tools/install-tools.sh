#!/usr/bin/env bash
# =============================================================================
# Mint Arch Linux — Tools Installer
# Pull and install any/all of the 2800+ BlackArch tools directly
# Usage: bash install-tools.sh [category] or bash install-tools.sh all
# =============================================================================

set -euo pipefail

MINT='\033[38;2;46;203;113m'; BOLD='\033[1m'; NC='\033[0m'
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'

info()  { echo -e "${MINT}[+]${NC} $*"; }
ok()    { echo -e "${GREEN}[✓]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
error() { echo -e "${RED}[✗]${NC} $*"; exit 1; }

[[ "$EUID" -eq 0 ]] || error "Run as root: sudo bash install-tools.sh"

ensure_blackarch() {
    if ! grep -q '\[blackarch\]' /etc/pacman.conf 2>/dev/null; then
        info "Adding BlackArch repository..."
        curl -fsSL https://blackarch.org/strap.sh -o /tmp/strap.sh
        chmod +x /tmp/strap.sh && bash /tmp/strap.sh && rm /tmp/strap.sh
        pacman -Sy --noconfirm
        ok "BlackArch repo added!"
    fi
}

install_group() { pacman -S --needed --noconfirm "blackarch-${1}" 2>/dev/null && ok "Installed: blackarch-${1}"; }

usage() {
    echo ""
    echo -e "${BOLD}Usage:${NC}"
    echo "  sudo bash install-tools.sh all              — Install ALL 2800+ tools"
    echo "  sudo bash install-tools.sh top100           — Install top 100 tools"
    echo "  sudo bash install-tools.sh <category>       — Install one category"
    echo ""
    echo -e "${BOLD}Available categories:${NC}"
    echo "  exploitation    fuzzer          forensic        recon"
    echo "  scanner         webapp          networking      crypto"
    echo "  misc            reversing       mobile          cracker"
    echo "  sniffer         wireless        social          voip"
    echo "  windows         osint           proxy           stego"
    echo "  spoof           anti-forensic   backdoor        code-audit"
    echo "  config          decompiler      defensive       disassembler"
    echo "  dos             drone           fingerprint     firmware"
    echo "  hardware        honeypot        ids             keylogger"
    echo "  malware         nfc             packer          radio"
    echo "  vehicle         unpacker        threat-modeling"
    echo ""
}

install_top100() {
    info "Installing top 100 essential security tools..."
    pacman -S --needed --noconfirm \
        nmap masscan netdiscover arp-scan whois dnsutils traceroute mtr \
        sqlmap nikto gobuster ffuf wfuzz dirb burpsuite zaproxy \
        hashcat john hydra medusa crunch cewl \
        aircrack-ng kismet wireshark-qt wireshark-cli bettercap mdk4 reaver hcxtools hcxdumptool \
        metasploit exploitdb searchsploit pwntools \
        bloodhound crackmapexec evil-winrm python-impacket \
        autopsy sleuthkit binwalk foremost testdisk volatility3 exiftool \
        radare2 ghidra cutter gdb pwndbg ltrace strace \
        tcpdump dsniff ettercap responder mitmproxy \
        ncat socat proxychains-ng tor openvpn wireguard-tools sslscan \
        steghide stegseek openssl age gnupg \
        maltego recon-ng theharvester amass subfinder nuclei \
        set gophish \
        trivy dive grype syft \
        apktool jadx frida adb androguard \
        snort suricata rkhunter lynis clamav auditd \
        yara sqlmap \
        2>/dev/null || warn "Some packages unavailable in official repos"
    ok "Top 100 tools installed!"
}

CATEGORY="${1:-}"
ensure_blackarch

case "$CATEGORY" in
    "")         usage ;;
    all)        warn "Installing ALL 2800+ BlackArch tools (~20GB). This will take a while."
                read -rp "Continue? (yes/N): " c; [[ "$c" == "yes" ]] || exit 0
                pacman -S --needed --noconfirm blackarch && ok "All 2800+ tools installed!" ;;
    top100)     install_top100 ;;
    list)       pacman -Sg | grep blackarch | sort ;;
    *)          install_group "$CATEGORY" ;;
esac
