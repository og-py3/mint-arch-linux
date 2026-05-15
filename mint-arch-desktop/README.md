# Mint Arch Linux — Browser Desktop

**Full KDE Plasma desktop running inside Docker, accessible from your browser on port 3000. No VNC client needed.**

```
  ███╗   ███╗██╗███╗   ██╗████████╗      █████╗ ██████╗  ██████╗██╗  ██╗
  ████╗ ████║██║████╗  ██║╚══██╔══╝     ██╔══██╗██╔══██╗██╔════╝██║  ██║
  ██╔████╔██║██║██╔██╗ ██║   ██║        ███████║██████╔╝██║     ███████║
  ██║╚██╔╝██║██║██║╚██╗██║   ██║        ██╔══██║██╔══██╗██║     ██╔══██║
  ██║ ╚═╝ ██║██║██║ ╚████║   ██║        ██║  ██║██║  ██║╚██████╗██║  ██║
  ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝        ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
                                                            L I N U X
```

Powered by [LinuxServer.io Webtop](https://docs.linuxserver.io/images/docker-webtop/) (`arch-kde` variant).

---

## Quick Start

### Option 1 — GitHub Codespaces (easiest, no setup)

1. Push this repo to GitHub
2. Click **Code → Codespaces → Create codespace**
3. Wait for it to build (~3–5 minutes first time)
4. Port 3000 opens automatically in your browser
5. Log in: `mint` / `mint`

### Option 2 — VS Code Dev Container

```bash
git clone https://github.com/yourusername/mint-arch-desktop
cd mint-arch-desktop
code .
# Click "Reopen in Container" when prompted
```

Port 3000 will open automatically in your browser.

### Option 3 — Docker (local)

```bash
git clone https://github.com/yourusername/mint-arch-desktop
cd mint-arch-desktop
chmod +x scripts/*.sh
bash scripts/start-desktop.sh
# Open http://localhost:3000
```

---

## Access

| Field | Value |
|---|---|
| **URL** | http://localhost:3000 |
| **Username** | `mint` |
| **Password** | `mint` |

---

## Features

| Feature | Details |
|---|---|
| **Desktop** | KDE Plasma (Arch Linux base) |
| **Access** | Browser via noVNC — no client needed |
| **Persistence** | Files saved in `mint-arch-data/` volume |
| **App installer** | Install & persist apps with one command |
| **Auto-restore** | Saved apps reinstalled on every start |
| **Mint Arch Tools** | All `mint-*` CLI tools available |

---

## Scripts

### `scripts/start-desktop.sh`
Starts (or resumes) the desktop. Run this every time.
```bash
bash scripts/start-desktop.sh
```

### `scripts/install-app.sh <package>`
Installs a package inside the desktop and saves it for next startup.
```bash
bash scripts/install-app.sh firefox
bash scripts/install-app.sh code          # VS Code
bash scripts/install-app.sh nmap
bash scripts/install-app.sh wireshark-qt
```

### `scripts/stop-desktop.sh`
Stops the desktop. Your files are preserved.
```bash
bash scripts/stop-desktop.sh
```

### `scripts/reset-desktop.sh`
Nuclear option — deletes everything for a fresh start.
```bash
bash scripts/reset-desktop.sh
```

---

## Installing Security Tools

Inside the desktop terminal, run:

```bash
# Individual tools (via pacman)
sudo pacman -S nmap wireshark-qt metasploit

# Or use Mint Arch Linux's built-in tool manager
# (copies tools list from your Mint Arch Linux source)
sudo mint-tools-setup
```

---

## Project Structure

```
mint-arch-desktop/
├── .devcontainer/
│   └── devcontainer.json       # VS Code / Codespaces config
├── scripts/
│   ├── start-desktop.sh        # Launch the desktop
│   ├── install-app.sh          # Install & persist apps
│   ├── stop-desktop.sh         # Stop the desktop
│   └── reset-desktop.sh        # Full reset (deletes data)
├── Dockerfile                  # Container image definition
└── README.md
```

---

## Configuration

| Variable | Default | Description |
|---|---|---|
| `TZ` | `UTC` | Timezone (e.g. `America/New_York`) |
| `PUID` | `1000` | User ID |
| `PGID` | `1000` | Group ID |
| `TITLE` | `Mint Arch Linux` | Browser tab title |

To change timezone, edit `scripts/start-desktop.sh` and set `TZ=Your/Timezone`.

---

## Persistent Storage

All your files, settings, and installed apps are saved in:
```
mint-arch-data/           ← mounted as /config inside container
└── saved-apps.txt        ← auto-reinstalled on every start
```

This folder survives container restarts and rebuilds.

---

## Credits

- [LinuxServer.io Webtop](https://docs.linuxserver.io/images/docker-webtop/) — browser-accessible desktop base
- [Arch Linux](https://archlinux.org) — base system
- [KDE Plasma](https://kde.org/plasma-desktop) — desktop environment
- Inspired by [og-py3/linux-kde-desktop](https://github.com/og-py3/linux-kde-desktop)
