# Mint Arch Linux

> Rolling Arch Linux — KDE Plasma 6 · Kali Linux Tools · BlackArch (2800+) · Auto-Updates · Browser Desktop

[![ISO Build #288](https://img.shields.io/badge/ISO%20Build%20%23288-passing-brightgreen?logo=github)](https://github.com/og-py3/mint-arch-linux/actions/runs/25957594755)
[![Latest Release](https://img.shields.io/github/v/release/og-py3/mint-arch-linux)](https://github.com/og-py3/mint-arch-linux/releases/latest)
[![License](https://img.shields.io/github/license/og-py3/mint-arch-linux)](LICENSE)

---

## Overview

**Mint Arch Linux** is a custom Arch Linux distribution with:
- **KDE Plasma 6** on Wayland — fast, modern desktop
- **All Kali Linux tools** mapped to BlackArch equivalents, pre-installed and on-demand
- **2800+ BlackArch tools** available with one command
- **Auto-updating system** — downloads and applies updates silently on boot, no new ISO needed
- **Browser-accessible desktop** via QEMU/noVNC — try it without installing
- **Rolling release** — always up-to-date via Arch Linux

---

## Auto-Update System

Mint Arch Linux updates itself automatically. You never need to download a new ISO to stay current.

| Phase | When | What happens |
|---|---|---|
| **Download** | 2 min after boot | `mint-autoupdate` checks for package updates and pre-downloads them to cache. A desktop notification appears when updates are ready. |
| **Apply** | Next boot (before login screen) | `mint-apply-updates` installs all cached packages silently before you even see the login screen. |
| **Tools** | Same as Download | Latest `mint-*` scripts pulled from GitHub and applied immediately. |
| **Version check** | Same as Download | Notifies you if a new Mint Arch Linux release is available. |

---

## ✅ ISO Build — v2026.05 Successful

| Property | Value |
|---|---|
| **Version** | v2026.05 |
| **Build Date** | 2026-05-16 |
| **Base** | Arch Linux (rolling) |
| **Desktop** | KDE Plasma 6 (Wayland) |
| **ISO Size** | ~10 GB |
| **Default user** | `mint` / `mint` |
| **Root password** | `toor` |

Download from the [Releases page](https://github.com/og-py3/mint-arch-linux/releases/latest).

---

## Installation

### Flash to USB (Linux / macOS)
```bash
sudo dd if=mintarch-2026.05.16-x86_64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

### Windows
Use [Rufus](https://rufus.ie), [balenaEtcher](https://etcher.balena.io), or [Ventoy](https://www.ventoy.net).

### VirtualBox / VMware / QEMU
```
New VM → Arch Linux 64-bit → Enable EFI → 4 GB RAM minimum → Attach ISO
```
Then run the installer:
```bash
sudo mint-installer
```

### Default credentials
| Field | Value |
|---|---|
| Username | `mint` |
| Password | `mint` |
| Root password | `toor` |

---

## Try Without Installing

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/og-py3/mint-arch-linux)

Opens the full Mint Arch Linux environment in a QEMU VM accessible from your browser via noVNC.

---

## Security Tools

### Pre-installed in ISO (works offline)

| Kali Category | Tools Included |
|---|---|
| Information Gathering | nmap, masscan, netdiscover, arp-scan, hping, dmitry, p0f, ncrack, enum4linux, smbmap, dnsenum, amass, subfinder, theharvester, spiderfoot, sslyze |
| Web Application | sqlmap, burpsuite, zaproxy, nikto, gobuster, ffuf, feroxbuster, wfuzz, commix, wapiti, wpscan, weevely, davtest |
| Password Cracking | hashcat, john, hydra, medusa, crunch, cewl, cupp, rainbowcrack, samdump2, ophcrack, seclists, rockyou |
| Wireless | aircrack-ng, kismet, wifite, wifiphisher, airgeddon, bettercap, hcxdumptool, hcxtools, reaver, pixiewps, mdk4 |
| Exploitation | metasploit, exploitdb, armitage, routersploit, beef, veil, shellter, python-pwntools, impacket |
| Post-Exploitation | crackmapexec, evil-winrm, bloodhound, mimikatz, smbclient, neo4j |
| Sniffing & MitM | wireshark, tcpdump, ettercap, mitmproxy, responder, scapy, driftnet, sslstrip, yersinia |
| Forensics | autopsy, sleuthkit, volatility3, binwalk, foremost, scalpel, exiftool, bulk-extractor, pdf-parser, oletools |
| Reverse Engineering | radare2, ghidra, cutter, gdb, pwndbg, apktool, jadx, edb, dex2jar |
| OSINT | maltego, recon-ng, sherlock, spiderfoot, metagoofil, photon, eyewitness |
| Social Engineering | setoolkit (SET) |
| Cloud & Container | trivy, grype, syft, pacu, scout-suite, prowler |
| Defensive | snort, suricata, rkhunter, lynis, chkrootkit, aide |

### Install all Kali tools on demand
```bash
sudo mint-tools-setup --all-kali
```

### Install by category
```bash
sudo mint-tools-setup --web          # Web application testing
sudo mint-tools-setup --wireless     # WiFi & wireless
sudo mint-tools-setup --forensics    # Digital forensics
sudo mint-tools-setup --exploit      # Exploitation frameworks
sudo mint-tools-setup --passwords    # Password cracking
sudo mint-tools-setup --osint        # OSINT tools
sudo mint-tools-setup --cloud        # Cloud & container security
```

### Install everything (2800+ BlackArch tools)
```bash
sudo mint-tools-setup --all-blackarch
```

### Interactive menu
```bash
sudo mint-tools-setup
```

---

## Repository Structure

```
mint-arch-linux/
├── .github/workflows/          # CI/CD pipelines
│   ├── build-iso.yml           # Builds ISO on push to mint-arch-linux/**
│   ├── release.yml             # Auto-publishes release with ISO on version tag push
│   └── attach-to-release.yml  # Manually attach existing artifact to a release
├── mint-arch-linux/            # ISO profile
│   ├── airootfs/               # Root filesystem overlay
│   │   ├── usr/local/bin/      # mint-* command suite
│   │   │   ├── mint-autoupdate     # Downloads package updates in background
│   │   │   ├── mint-apply-updates  # Applies cached updates on next boot
│   │   │   ├── mint-tools-setup    # Kali + BlackArch tool installer
│   │   │   ├── mint-update         # Manual safe update (with snapshots)
│   │   │   └── mint-installer      # System installer
│   │   └── etc/systemd/system/ # Systemd units
│   ├── packages.x86_64/        # Package lists baked into ISO
│   │   └── security.txt        # All pre-installed security tools
│   └── profiledef.sh           # mkarchiso profile
└── mint-arch-desktop/          # Browser desktop (QEMU/noVNC)
```

---

## Building the ISO

The ISO builds automatically on GitHub Actions when files in `mint-arch-linux/**` change.
To trigger a manual build: **Actions → Build Mint Arch Linux ISO → Run workflow**.

To publish a release with the ISO attached automatically:
```bash
git tag v2026.06 && git push origin v2026.06
```

---

## Contributing

Pull requests are welcome. For major changes, open an issue first.

---

## License

Open source. See [LICENSE](LICENSE) for details.

---

*Built on Arch Linux · Powered by BlackArch · Kali Linux tool parity · KDE Plasma 6*