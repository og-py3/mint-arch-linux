<div align="center">

```
███╗   ███╗██╗███╗   ██╗████████╗      █████╗ ██████╗  ██████╗██╗  ██╗
████╗ ████║██║████╗  ██║╚══██╔══╝     ██╔══██╗██╔══██╗██╔════╝██║  ██║
██╔████╔██║██║██╔██╗ ██║   ██║        ███████║██████╔╝██║     ███████║
██║╚██╔╝██║██║██║╚██╗██║   ██║        ██╔══██║██╔══██╗██║     ██╔══██║
██║ ╚═╝ ██║██║██║ ╚████║   ██║        ██║  ██║██║  ██║╚██████╗██║  ██║
╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝        ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
```

**A rolling Arch Linux distribution — built for security professionals, developers, and power users.**

[![ISO Build](https://img.shields.io/badge/ISO%20Build-Coming%20Soon-orange?logo=linux&logoColor=white)](https://github.com/og-py3/mint-arch-linux/actions/workflows/build-iso.yml)
[![Release](https://img.shields.io/github/v/release/og-py3/mint-arch-linux?color=2ecb71&label=latest)](https://github.com/og-py3/mint-arch-linux/releases)
[![License](https://img.shields.io/badge/license-MIT-2ecb71)](LICENSE)
[![BlackArch](https://img.shields.io/badge/BlackArch-2800%2B%20tools-red)](https://blackarch.org)
[![KDE Plasma](https://img.shields.io/badge/KDE-Plasma%206-1d99f3)](https://kde.org/plasma-desktop)
[![Arch Based](https://img.shields.io/badge/base-Arch%20Linux-1793d1)](https://archlinux.org)
[![Open in Codespaces](https://img.shields.io/badge/Try%20Now-Open%20in%20Codespaces-2ecb71?logo=github)](https://codespaces.new/og-py3/mint-arch-linux)

</div>

---

## Overview

Mint Arch Linux is a fully customized, rolling-release Linux distribution built on top of Arch Linux. It ships with a polished KDE Plasma 6 desktop, 150+ pre-installed security tools, access to the full BlackArch repository (2800+ tools), and a browser-accessible desktop that runs directly in GitHub Codespaces — no hardware required.

Whether you're doing penetration testing, security research, CTF challenges, or just want a fast, beautiful Arch-based system — Mint Arch Linux has you covered out of the box.

---

## What's Inside

| Directory | Description |
|---|---|
| [`mint-arch-linux/`](./mint-arch-linux/) | Full distro source — build a bootable ISO with archiso |
| [`mint-arch-desktop/`](./mint-arch-desktop/) | Browser-accessible KDE desktop via Docker & GitHub Codespaces |
| [`tools/`](./tools/) | Security tool reference list + install scripts for all 2800+ BlackArch tools |
| [`.github/workflows/`](./.github/workflows/) | CI/CD — auto ISO builds + release publishing on version tags |

---

## Try It Right Now

No ISO, no install, no hardware needed.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/og-py3/mint-arch-linux)

> Click the button above → Codespaces builds the Mint Arch Linux desktop → KDE Plasma opens in your browser on port 3000.
> Login: **mint** / **mint**

Or run it locally with Docker:

```bash
git clone https://github.com/og-py3/mint-arch-linux
cd mint-arch-linux/mint-arch-desktop
bash scripts/start-desktop.sh
# Open http://localhost:3000
```

---

## Features

### Desktop
- **KDE Plasma 6** — Wayland-first, full compositor with blur and translucency
- **Live Video Wallpaper** — Minecraft Northern Lights (4K, hardware-accelerated, 30fps cap)
- **Frosted Glass UI** — per-app translucency, KWin blur strength 9
- **Custom SDDM Login Screen** — video background, frosted glass card, live clock
- **ZSH + Starship** — fast, informative terminal prompt with Nerd Font icons
- **JetBrains Mono Nerd Font** — throughout the entire system

### Security
- **150+ tools pre-installed** — ready to use offline from first boot
- **BlackArch repository** — 2800+ additional tools, one command away
- **22+ tool categories** — recon, exploitation, forensics, wireless, OSINT, and more
- **`mint-tools-setup`** — interactive menu to install any BlackArch tool group
- **Metasploit, Ghidra, Wireshark, Hashcat, Aircrack-ng** and many more built in

### System
- **Rolling release** — always up to date, never reinstall
- **Btrfs + Snapper** — automatic snapshots before every update, easy rollback
- **Auto-update from GitHub** — `mint-autoupdate` pulls and applies improvements on every boot
- **zram swap** — compressed RAM swap for better performance on all systems
- **Flatpak + Flathub** — pre-configured, install any app in seconds
- **AppArmor + UFW** — security hardening enabled by default

### Development
- **AUR support** — `paru` helper via `mint-setup-aur`
- **Docker** — pre-installed and enabled
- **Python, git, base-devel** — all included
- **GitHub Codespaces** — full dev environment in the browser

---

## Building the ISO

### Option 1 — GitHub Actions (zero setup, recommended)

Every push to `main` automatically builds the ISO. To download it:

1. Go to [Actions](https://github.com/og-py3/mint-arch-linux/actions)
2. Click the latest **Build Mint Arch Linux ISO** run
3. Download from the **Artifacts** section

### Option 2 — Create a release with ISO attached

```bash
git tag v2025.05
git push origin v2025.05
```

GitHub builds the ISO, signs the checksums, and publishes a release at
[github.com/og-py3/mint-arch-linux/releases](https://github.com/og-py3/mint-arch-linux/releases) — automatically.

### Option 3 — Build locally on Arch Linux

```bash
sudo pacman -S archiso
cd mint-arch-linux
sudo ./build.sh
# Output: mint-arch-linux/output/mintarch-YYYY.MM.DD-x86_64.iso
```

### Option 4 — Build inside Docker (Windows / Mac / Linux)

```bash
cd mint-arch-linux/docker-build
bash build.sh
```

---

## Installing

Flash the ISO to a USB drive:

```bash
# Linux / macOS
sudo dd if=mintarch-*.iso of=/dev/sdX bs=4M status=progress oflag=sync

# Windows
# Use Rufus, balenaEtcher, or Ventoy
```

Boot from USB → run the graphical installer:

```bash
sudo mint-installer
```

**Recommended partition layout:**

| Mount | Size | Filesystem |
|---|---|---|
| `/boot/efi` | 512 MB | FAT32 |
| `/` | 40 GB+ | Btrfs |
| `/home` | remaining | Btrfs |
| swap | — | zram (auto-configured) |

---

## Security Tools

Mint Arch Linux ships with 150+ tools pre-installed and gives you access to the full BlackArch suite on demand.

### Pre-installed (works offline)

| Category | Tools |
|---|---|
| Network Scanning | nmap, masscan, netdiscover, arp-scan, hping |
| Web Testing | sqlmap, nikto, gobuster, ffuf, burpsuite, zaproxy |
| Password Cracking | hashcat, john, hydra, medusa, crunch |
| Wireless | aircrack-ng, kismet, wireshark, bettercap, hcxtools |
| Exploitation | metasploit, exploitdb, pwntools, impacket |
| Forensics | autopsy, volatility3, binwalk, exiftool, sleuthkit |
| Reverse Engineering | radare2, ghidra, gdb, pwndbg, jadx, apktool |
| Post-Exploitation | crackmapexec, evil-winrm, bloodhound |
| OSINT | maltego, sherlock, theharvester, amass, recon-ng |
| Sniffing | tcpdump, wireshark, ettercap, responder, mitmproxy |
| Defensive | snort, suricata, rkhunter, lynis, clamav, auditd |

> Full list → [`tools/tools-list.txt`](./tools/tools-list.txt)

### Install more tools

```bash
# Interactive menu — pick by category
sudo mint-tools-setup

# Install a specific BlackArch group
sudo pacman -S blackarch-webapp
sudo pacman -S blackarch-recon
sudo pacman -S blackarch-forensic

# Install all 2800+ tools (~20GB)
sudo pacman -S blackarch

# Script from this repo
sudo bash tools/install-tools.sh top100    # top 100 tools
sudo bash tools/install-tools.sh webapp    # one category
sudo bash tools/install-tools.sh all       # everything
```

---

## mint-* Commands

Mint Arch Linux ships with 16 custom CLI tools for managing your system:

| Command | Description |
|---|---|
| `mint-tools-setup` | Interactive installer for 2800+ BlackArch security tools |
| `mint-autoupdate` | Pull and apply updates from GitHub on boot |
| `mint-live-wallpaper` | Start / restart the live video wallpaper |
| `mint-update` | Full system update — pacman + AUR + Flatpak + firmware |
| `mint-installer` | Launch the Calamares graphical disk installer |
| `mint-snapshot` | Create, list, and restore Btrfs snapshots |
| `mint-backup` | Backup manager |
| `mint-health` | Disk SMART, memory, and temperature check |
| `mint-hardware` | Hardware info and driver detection |
| `mint-driver-manager` | Auto-install missing GPU / WiFi drivers |
| `mint-optimizer` | Performance tuning — swappiness, I/O scheduler, CPU governor |
| `mint-privacy` | Enable UFW, AppArmor, DNS-over-HTTPS |
| `mint-gaming` | Install Steam, Lutris, Wine, DXVK, Proton |
| `mint-setup-aur` | Install paru (AUR helper) |
| `mint-clean` | Remove orphans, cache, temp files |
| `mint-doctor` | Full system diagnostics and repair suggestions |
| `mint-fetch` | System info display (like neofetch) |
| `mint-welcome` | First-run setup wizard |

---

## Default Credentials

| | |
|---|---|
| Live username | `mint` |
| Live password | `mint` |
| Root password | `toor` |

> Change these immediately after installing to disk.

---

## Auto-Update

Mint Arch Linux automatically checks GitHub for improvements on every boot (requires internet). When an update is found:

- All `mint-*` tools are silently updated
- Wallpapers and assets are refreshed
- A desktop notification is shown
- Your personal files and configs are **never** touched

To check update status manually:

```bash
sudo mint-autoupdate
cat /var/lib/mint-arch/last-commit
journalctl -u mint-autoupdate
```

---

## Project Structure

```
mint-arch-linux/
├── .github/
│   ├── workflows/
│   │   ├── build-iso.yml          # Builds ISO on every push to main
│   │   └── release.yml            # Publishes ISO release on git tag
│   └── ISSUE_TEMPLATE/
├── mint-arch-linux/               # Distro source (archiso profile)
│   ├── airootfs/
│   │   ├── usr/local/bin/         # All 18 mint-* tools
│   │   ├── etc/skel/.config/      # KDE, KWin, Plasma defaults
│   │   ├── usr/share/mint-arch/
│   │   │   └── wallpapers/        # Live video wallpaper
│   │   └── usr/share/sddm/themes/ # Custom SDDM login screen
│   ├── packages.x86_64/           # Package lists (base, desktop, security)
│   ├── calamares/                 # Graphical installer config
│   ├── grub/themes/mint/          # GRUB bootloader theme
│   ├── build.sh                   # ISO build script
│   └── profiledef.sh              # archiso profile definition
├── mint-arch-desktop/             # Browser desktop
│   ├── Dockerfile                 # Builds the KDE browser image
│   ├── .devcontainer/             # GitHub Codespaces config
│   └── scripts/                   # start / stop / reset / install-app
└── tools/
    ├── tools-list.txt             # Full reference of all 2800+ tools
    └── install-tools.sh           # Install any tool or group via CLI
```

---

## Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](./CONTRIBUTING.md) before opening a pull request.

```bash
# Fork, clone, branch
git checkout -b feature/my-feature

# Make changes, then push
git push origin feature/my-feature

# Open a pull request on GitHub
```

Report bugs → [Issues](https://github.com/og-py3/mint-arch-linux/issues/new?template=bug_report.md)
Request features → [Issues](https://github.com/og-py3/mint-arch-linux/issues/new?template=feature_request.md)

---

## Credits

| Project | Role |
|---|---|
| [Arch Linux](https://archlinux.org) | Base system and package ecosystem |
| [BlackArch Linux](https://blackarch.org) | Security tools repository (2800+ tools) |
| [KDE Plasma](https://kde.org/plasma-desktop) | Desktop environment |
| [archiso](https://wiki.archlinux.org/title/Archiso) | ISO build framework |
| [LinuxServer.io Webtop](https://docs.linuxserver.io/images/docker-webtop/) | Browser desktop base |
| [Snapper](http://snapper.io) | Btrfs snapshot management |
| [mpvpaper](https://github.com/GhostNaN/mpvpaper) | Live video wallpaper (Wayland) |

---

<div align="center">

**MIT License** · Built on Arch · Powered by BlackArch · KDE Plasma 6

[⬆ Back to top](#)

</div>
