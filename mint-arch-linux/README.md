# Mint Arch Linux

**Rolling Arch Linux · KDE Plasma 6 · Security Tools · Developer-Ready · Black + Mint-Green Aesthetic**

```
  ███╗   ███╗██╗███╗   ██╗████████╗      █████╗ ██████╗  ██████╗██╗  ██╗
  ████╗ ████║██║████╗  ██║╚══██╔══╝     ██╔══██╗██╔══██╗██╔════╝██║  ██║
  ██╔████╔██║██║██╔██╗ ██║   ██║        ███████║██████╔╝██║     ███████║
  ██║╚██╔╝██║██║██║╚██╗██║   ██║        ██╔══██║██╔══██╗██║     ██╔══██║
  ██║ ╚═╝ ██║██║██║ ╚████║   ██║        ██║  ██║██║  ██║╚██████╗██║  ██║
  ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝        ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
                                                            L I N U X
```

**Mint Arch Linux** is a standalone, professional-grade rolling Linux distribution built on Arch Linux. It ships with KDE Plasma 6 (Wayland-first), a dark mint-green glassmorphism aesthetic, curated security tools, Btrfs+Snapper snapshots, 16 custom `mint-*` CLI tools, and a full developer environment — all from official Arch repos and AUR. No third-party repos required.

---

## Features

| Feature | Details |
|---|---|
| **Base** | Arch Linux (rolling release) |
| **Desktop** | KDE Plasma 6 — Wayland + X11 (choose at login) |
| **Shell** | ZSH with autosuggestions + syntax highlighting |
| **Security Tools** | Curated set pre-installed; 22 categories available via `mint-tools-setup` |
| **Stability** | Btrfs + Snapper snapshots — auto rollback before every update |
| **Privacy** | AppArmor, UFW firewall, DNS-over-HTTPS, kernel hardening |
| **Gaming** | Optional Steam, Wine, Proton, MangoHud via `mint-gaming` |
| **VMs** | VMware, VirtualBox, QEMU guest tools pre-installed |
| **AUR** | `paru` AUR helper installable via `mint-setup-aur` |
| **Flatpak** | Flathub pre-configured out of the box |

---

## Mint Arch Linux Tool Suite

All tools are built-in and branded as Mint Arch Linux — no dependency on any external distribution.

| Command | Description |
|---|---|
| `mint-installer` | Guided disk installer (Btrfs or ext4, GPT, EFI) |
| `mint-tools-setup` | Install security tool categories (22 categories, official repos only) |
| `mint-update` | Safe update — creates a snapshot before every update |
| `mint-hardware` | Auto-detects GPU/CPU, installs correct drivers + microcode |
| `mint-privacy` | One-command: firewall + DNS-over-HTTPS + kernel hardening + AppArmor |
| `mint-health` | Live dashboard: CPU temp, RAM, drive SMART, network, security status |
| `mint-snapshot` | Btrfs snapshot manager — create, list, compare, rollback |
| `mint-gaming` | Gaming setup: Steam, Wine, Proton, MangoHud, GameMode |
| `mint-setup-aur` | Builds and installs `paru` AUR helper |
| `mint-fetch` | System info display |
| `mint-clean` | Disk space cleaner |
| `mint-doctor` | System diagnostics |
| `mint-backup` | Backup manager |
| `mint-optimizer` | Performance optimizer |
| `mint-driver-manager` | GPU/CPU driver manager |
| `mint-welcome` | First-run setup wizard |

---

## Building the ISO

### Requirements

- **Host OS:** Arch Linux (any Arch-based distro)
- **Package:** `archiso`
- **Disk space:** ~15GB free in `/tmp`
- **Internet:** Required (packages downloaded during build)

### Steps

```bash
# 1. Install archiso
sudo pacman -S archiso git

# 2. Clone this repo
git clone https://github.com/yourusername/mint-arch-linux
cd mint-arch-linux

# 3. Build the ISO (must run as root)
sudo ./build.sh

# ISO appears in: ./output/mintarch-YYYY.MM.DD-x86_64.iso
```

### Options

```bash
sudo ./build.sh --clean           # Clean previous build artifacts first
sudo ./build.sh --output /path    # Set custom output directory
```

---

## Flashing to USB

### Linux
```bash
sudo dd if=output/mintarch-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
# Replace /dev/sdX with your USB device (check with: lsblk)
```

### Windows / macOS
Use **[balenaEtcher](https://etcher.balena.io)** — free and easy.

### Ventoy
Drop the ISO onto your Ventoy USB drive — no flashing needed.

---

## VM Usage

Works out of the box in:
- **VirtualBox** — Enable EFI in VM settings
- **VMware Workstation / Player** — BIOS or EFI
- **QEMU/KVM** — Use `-machine q35`
- **Hyper-V** — Enable Enhanced Session mode

---

## Installing to Disk

Boot the live ISO, open a terminal, and run:

```bash
sudo mint-installer
```

The installer handles:
1. Disk selection and partitioning (GPT + EFI + swap + root)
2. Filesystem choice (Btrfs with subvolumes, or ext4)
3. Username, password, hostname
4. Timezone (auto-detected)
5. Session selection (Wayland or X11)
6. Optional gaming support (Steam, Wine, Proton)
7. GRUB bootloader install

---

## Security Tools

Run `sudo mint-tools-setup` to install tool categories on demand:

- Information Gathering, Reconnaissance, Web Apps
- Password Cracking, Wireless, Exploitation
- Post-Exploitation, Forensics, Reverse Engineering
- Sniffing & Spoofing, Network Tools, Crypto/Steganography
- OSINT, Social Engineering, Fuzzing
- Container Security, Mobile, VoIP, Defensive, Database, Firmware

All packages come from official Arch Linux repositories (`[core]`, `[extra]`, `[community]`) and AUR — no third-party repositories required.

---

## Default Credentials (Live Session)

| Field | Value |
|---|---|
| **Username** | `mint` |
| **Password** | `mint` |
| **Root password** | `toor` |

---

## Project Structure

```
mint-arch-linux/
├── profiledef.sh                       # archiso profile definition
├── pacman.conf                         # Pacman — official repos only
├── build.sh                           # ISO build script
├── packages.x86_64/
│   ├── base.txt                       # Base system packages
│   ├── desktop.txt                    # KDE Plasma packages
│   ├── security.txt                   # Default security tools
│   ├── dev.txt                        # Developer tools
│   ├── gaming.txt                     # Gaming packages
│   └── extras.txt                     # Flatpak, extras
├── airootfs/
│   ├── etc/
│   │   ├── os-release                 # Mint Arch Linux identity
│   │   ├── motd                       # Login message
│   │   ├── sddm.conf.d/               # Login screen config
│   │   └── skel/                      # Default user dotfiles
│   └── usr/
│       ├── local/bin/                 # All mint-* tools
│       └── share/
│           ├── pixmaps/mintarch-logo.png
│           └── mint-arch/
│               ├── logo.png
│               └── grub-theme/
├── calamares/                         # Graphical installer config
├── efiboot/                           # UEFI boot entries
├── syslinux/                          # Legacy BIOS boot
└── docker-build/                      # Docker-based build environment
```

---

## Customizing

- **Add packages** — Edit files in `packages.x86_64/`
- **Change security tools** — Edit `packages.x86_64/security.txt`
- **Add scripts/configs** — Drop files in `airootfs/` (copied directly into ISO)
- **Change desktop** — Swap `plasma-meta` in `desktop.txt` for `gnome`, `xfce4`, etc.

---

## Credits

- [Arch Linux](https://archlinux.org) — Base system and package ecosystem
- [archiso](https://wiki.archlinux.org/title/Archiso) — Official ISO build framework
- [BlackArch Linux](https://blackarch.org) — Security tools reference
- [KDE Plasma](https://kde.org/plasma-desktop) — Desktop environment
- [Snapper](http://snapper.io) — Snapshot and rollback system
