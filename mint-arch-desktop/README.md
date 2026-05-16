# Mint Arch Linux — Browser VM Desktop

**The real Mint Arch Linux ISO running in a QEMU virtual machine, accessible from your browser. No installation, no VNC client — just open the link.**

---

## How it works

```
  Your Browser
      │
      │  HTTP (noVNC)
      ▼
  Port 3000  ──►  websockify  ──►  VNC :5900  ──►  QEMU VM
                                                       │
                                                  Mint Arch Linux ISO
                                                  (real KDE Plasma 6)
```

The VM boots the actual Mint Arch Linux ISO in QEMU. Everything you see is the real system — not a simulation.

---

## Quick Start

### Option 1 — GitHub Codespaces (easiest, no setup)

1. Click **Code → Codespaces → Create codespace on main**
2. Wait for the container to build (~3–5 min first time)
3. Port 3000 opens automatically in your browser
4. The VM starts and boots Mint Arch Linux
5. Log in: `mint` / `mint`

> **Note:** Codespaces uses software emulation (no KVM), so boot takes ~2–3 min.

---

### Option 2 — VS Code Dev Container

```bash
git clone https://github.com/og-py3/mint-arch-linux
cd mint-arch-linux
code .
# Click "Reopen in Container" when prompted
# Open http://localhost:3000/vnc.html
```

---

### Option 3 — Docker (local, fastest with KVM)

```bash
git clone https://github.com/og-py3/mint-arch-linux
cd mint-arch-linux

docker build -t mintarch-vm -f mint-arch-desktop/Dockerfile .

# With KVM (fast — Linux hosts only)
docker run --rm --privileged --device=/dev/kvm \
    -p 3000:3000 -p 5900:5900 \
    -v mintarch-data:/vm \
    mintarch-vm

# Without KVM (slower, works on Mac/Windows)
docker run --rm --privileged \
    -p 3000:3000 -p 5900:5900 \
    -v mintarch-data:/vm \
    mintarch-vm

# Open http://localhost:3000/vnc.html
```

---

## Access

| Field | Value |
|---|---|
| **URL** | http://localhost:3000/vnc.html |
| **Username** | `mint` |
| **Password** | `mint` |
| **VNC (raw)** | localhost:5900 (any VNC client) |

---

## What you get

| Feature | Details |
|---|---|
| **System** | Real Mint Arch Linux ISO in QEMU |
| **Desktop** | KDE Plasma 6 (Wayland) |
| **Access** | Browser via noVNC — no client needed |
| **Disk** | 20 GB virtual disk (persistent across restarts) |
| **ISO** | Auto-downloaded from latest GitHub release |
| **KVM** | Auto-detected — hardware acceleration when available |

---

## Install to the virtual disk

Inside the VM terminal:

```bash
sudo mint-installer
```

This installs Mint Arch Linux permanently to the 20 GB virtual disk. On next boot, remove the ISO from QEMU boot order and it will boot from the installed disk.

---

## Scripts

| Script | Purpose |
|---|---|
| `scripts/start-vm.sh` | Start the VM (downloads ISO if needed) |
| `scripts/stop-desktop.sh` | Stop the running VM |
| `scripts/reset-desktop.sh` | Delete virtual disk, start fresh |

---

## VM Configuration

Edit environment variables to customise the VM:

| Variable | Default | Description |
|---|---|---|
| `VM_RAM` | `2048` | RAM in MB |
| `VM_CPUS` | `2` | CPU cores |
| `DISK_SIZE` | `20G` | Virtual disk size |
| `ISO_PATH` | `/vm/mintarch.iso` | Path to the ISO |
| `NOVNC_PORT` | `3000` | Browser port |
| `VNC_PORT` | `5900` | VNC port |

---

## Building your own ISO

The ISO is built automatically by GitHub Actions:

1. Go to **Actions → Build Mint Arch Linux ISO → Run workflow**
2. Wait ~30–60 minutes
3. Download the ISO artifact, or publish a GitHub Release
4. The VM will auto-download from the latest release on next start

---

## Credits

- [QEMU](https://www.qemu.org/) — machine emulator and virtualizer
- [noVNC](https://novnc.com/) — browser-based VNC client
- [OVMF](https://github.com/tianocore/tianocore.github.io/wiki/OVMF) — UEFI firmware for VMs
- [Arch Linux](https://archlinux.org) — base system
- [KDE Plasma](https://kde.org/plasma-desktop) — desktop environment
