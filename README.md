# Mint Arch Linux

  > Rolling Arch Linux — KDE Plasma 6 · 150+ Security Tools · Browser Desktop

  [![ISO Build](https://github.com/og-py3/mint-arch-linux/actions/workflows/build-iso.yml/badge.svg)](https://github.com/og-py3/mint-arch-linux/actions/workflows/build-iso.yml)
  [![Latest Release](https://img.shields.io/github/v/release/og-py3/mint-arch-linux)](https://github.com/og-py3/mint-arch-linux/releases/latest)
  [![License](https://img.shields.io/github/license/og-py3/mint-arch-linux)](LICENSE)

  ---

  ## Overview

  **Mint Arch Linux** is a custom Arch Linux distribution pre-loaded with KDE Plasma 6, 150+ security and penetration-testing tools from BlackArch, and a browser-accessible desktop — all on a rolling-release base.

  It is built for security researchers, ethical hackers, and power users who want a clean, fast, and tool-rich environment without manual setup.

  ---

  ## ✅ ISO Build — v2026.05 Successful

  The ISO for **v2026.05** was built and verified successfully.

  | Property | Value |
  |---|---|
  | **Version** | v2026.05 |
  | **Build Date** | 2026-05-16 |
  | **Base** | Arch Linux (rolling) |
  | **Desktop** | KDE Plasma 6 (Wayland) |
  | **ISO Size** | ~10 GB |
  | **SHA256** | `6a4c2c52d6b410537516b2033f8533167005e88837b5372b36ff74beef74303b` |
  | **MD5** | `d451ed5f5f4dc97c59931926e0c5dd91` |

  Download the ISO from the [Releases page](https://github.com/og-py3/mint-arch-linux/releases/latest).

  ---

  ## Features

  - **Rolling release** — always up-to-date via Arch Linux + BlackArch repositories
  - **KDE Plasma 6** on Wayland — fast, modern, and polished desktop environment
  - **150+ pre-installed security tools** across 9 categories
  - **2800+ additional tools** available instantly via `sudo mint-tools-setup`
  - **Browser desktop** — access the live environment via QEMU/noVNC without installing
  - **Try in Codespaces** — spin up a full VM in your browser for free

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

  ## Pre-installed Security Tools

  | Category | Tools |
  |---|---|
  | Network Scanning | nmap, masscan, netdiscover, arp-scan, hping3 |
  | Web Testing | sqlmap, nikto, gobuster, ffuf, wfuzz, zaproxy |
  | Password Cracking | hashcat, john, hydra, medusa, crunch |
  | Wireless | aircrack-ng, kismet, wireshark, bettercap, hcxtools |
  | Exploitation | metasploit, exploitdb, python-pwntools, impacket |
  | Forensics | autopsy, volatility3, binwalk, exiftool, sleuthkit |
  | Reverse Engineering | radare2, ghidra, gdb, pwndbg, jadx |
  | OSINT | maltego, sherlock, theharvester, amass, spiderfoot |
  | Defensive | snort, suricata, rkhunter, lynis, clamav |

  > Install 2800+ more BlackArch tools:
  > ```bash
  > sudo mint-tools-setup
  > ```

  ---

  ## Building the ISO

  ```bash
  # Clone the repo
  git clone https://github.com/og-py3/mint-arch-linux.git
  cd mint-arch-linux

  # Build (requires Arch Linux host or container)
  sudo mkarchiso -v -w /tmp/archiso-work -o /tmp/out profiledef.sh
  ```

  The GitHub Actions workflow (`.github/workflows/build-iso.yml`) runs this automatically on every push to `main`.

  ---

  ## Repository Structure

  ```
  mint-arch-linux/
  ├── .github/workflows/      # CI/CD — ISO build pipeline
  ├── airootfs/               # Root filesystem overlay
  │   ├── etc/                # System configuration
  │   └── usr/                # Custom scripts & tools
  ├── efiboot/                # EFI boot files
  ├── syslinux/               # BIOS boot files
  ├── packages.x86_64         # Package list
  └── profiledef.sh           # mkarchiso profile definition
  ```

  ---

  ## Contributing

  Pull requests are welcome. For major changes, open an issue first to discuss what you'd like to change.

  ---

  ## License

  This project is open source. See [LICENSE](LICENSE) for details.

  ---

  *Built on Arch Linux · Powered by BlackArch · KDE Plasma 6*
  