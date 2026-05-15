# Mint Arch Linux

**By Haripriyan N**


**Rolling Arch Linux · KDE Plasma 6 · Security Tools · Browser Desktop · Developer-Ready**

```
  ███╗   ███╗██╗███╗   ██╗████████╗      █████╗ ██████╗  ██████╗██╗  ██╗
  ████╗ ████║██║████╗  ██║╚══██╔══╝     ██╔══██╗██╔══██╗██╔════╝██║  ██║
  ██╔████╔██║██║██╔██╗ ██║   ██║        ███████║██████╔╝██║     ███████║
  ██║╚██╔╝██║██║██║╚██╗██║   ██║        ██╔══██║██╔══██╗██║     ██╔══██║
  ██║ ╚═╝ ██║██║██║ ╚████║   ██║        ██║  ██║██║  ██║╚██████╗██║  ██║
  ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝        ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
                                                            L I N U X
```

---

## What's Inside

| Folder | Purpose |
|---|---|
| [`mint-arch-linux/`](./mint-arch-linux/) | Full distro source — build a bootable ISO |
| [`mint-arch-desktop/`](./mint-arch-desktop/) | Browser-accessible KDE desktop via Docker/Codespaces |

---

## Quick Start

### Test it in your browser (no hardware needed)

```bash
cd mint-arch-desktop
bash scripts/start-desktop.sh
# Open http://localhost:3000  —  login: mint / mint
```

Or open in **GitHub Codespaces** — port 3000 auto-opens.

### Build the real ISO

```bash
cd mint-arch-linux
sudo pacman -S archiso     # on Arch Linux host
sudo ./build.sh
# ISO: output/mintarch-YYYY.MM.DD-x86_64.iso
```

Or build with Docker (works on Windows/Mac/Linux):

```bash
cd mint-arch-linux/docker-build
bash build.sh
```

---

## Features

| Feature | Details |
|---|---|
| **Base** | Arch Linux (rolling release) |
| **Desktop** | KDE Plasma 6 — Wayland-first |
| **Shell** | ZSH + Starship prompt |
| **Security Tools** | 22 categories via `mint-tools-setup` |
| **Stability** | Btrfs + Snapper auto-snapshots |
| **Privacy** | AppArmor, UFW, DNS-over-HTTPS |
| **Gaming** | Steam, Wine, Proton via `mint-gaming` |
| **AUR** | paru helper via `mint-setup-aur` |
| **Flatpak** | Flathub pre-configured |
| **Browser Desktop** | Full KDE in browser via noVNC |

---

## Mint Arch Linux Tool Suite

| Command | Description |
|---|---|
| `mint-installer` | Guided disk installer |
| `mint-tools-setup` | Install security tool categories |
| `mint-update` | Safe update with auto-snapshot |
| `mint-hardware` | GPU/CPU driver auto-install |
| `mint-privacy` | Firewall + AppArmor + DNS hardening |
| `mint-health` | Live system dashboard |
| `mint-snapshot` | Btrfs snapshot manager |
| `mint-gaming` | Steam, Wine, Proton setup |
| `mint-setup-aur` | Install paru AUR helper |
| `mint-fetch` | System info display |
| `mint-clean` | Disk space cleaner |
| `mint-doctor` | System diagnostics |
| `mint-backup` | Backup manager |
| `mint-optimizer` | Performance optimizer |
| `mint-driver-manager` | Driver management |
| `mint-welcome` | First-run wizard |

---

## Default Credentials

| Field | Value |
|---|---|
| **Live username** | `mint` |
| **Live password** | `mint` |
| **Root password** | `toor` |

---

## License

MIT — use, modify, and distribute freely.

---

## Credits

- [Arch Linux](https://archlinux.org) — base system
- [archiso](https://wiki.archlinux.org/title/Archiso) — ISO build framework
- [BlackArch Linux](https://blackarch.org) — security tools reference
- [KDE Plasma](https://kde.org/plasma-desktop) — desktop environment
- [LinuxServer.io Webtop](https://docs.linuxserver.io/images/docker-webtop/) — browser desktop
- [Snapper](http://snapper.io) — snapshot system
