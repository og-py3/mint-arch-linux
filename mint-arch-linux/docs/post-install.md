# Mint OS — Post-Installation Guide

After running `sudo mint-installer` and rebooting into your installed Mint OS, follow this guide to finish setup.

---

## First Boot

You'll see the **Mint OS Welcome Wizard** automatically. It walks you through:

1. System update
2. AUR helper (paru) installation
3. Privacy & security hardening
4. Hardware driver setup
5. Security tools
6. Gaming support (optional)

If the wizard doesn't appear, run it manually:
```bash
mint-welcome
```

---

## Mint OS CLI Tools Reference

All tools are in `/usr/local/bin/` and available from any terminal.

| Tool | Run As | Purpose |
|------|--------|---------|
| `mint-fetch` | user | System info display |
| `mint-health` | sudo | Live health dashboard |
| `mint-update` | sudo | Safe system update with snapshot |
| `mint-clean` | sudo | Clean disk space |
| `mint-doctor` | sudo | Full system diagnostics |
| `mint-optimizer` | sudo | Performance profile switcher |
| `mint-driver-manager` | sudo | Auto-install hardware drivers |
| `mint-backup` | user | Backup manager |
| `mint-snapshot` | sudo | Btrfs snapshot manager |
| `mint-tools-setup` | sudo | Security tools installer |
| `mint-privacy` | sudo | Privacy & firewall hardening |
| `mint-gaming` | sudo | Gaming support (Steam, Proton) |
| `mint-hardware` | sudo | Hardware info & tuning |
| `mint-welcome` | user | Re-run first-run wizard |

---

## Install the AUR Helper (paru)

```bash
mint-setup-aur
```

After this, install any AUR package:
```bash
paru -S package-name
```

---

## Performance Profiles

```bash
sudo mint-optimizer          # Interactive menu
sudo mint-optimizer --gaming # Apply gaming profile directly
sudo mint-optimizer --battery # Apply battery saver
```

---

## Enabling Gaming Mode

```bash
sudo mint-gaming
```

Installs Steam, Lutris, Wine, Proton, GameMode, MangoHud.

---

## Security Hardening

```bash
sudo mint-privacy
```

Configures:
- UFW firewall (enabled by default)
- AppArmor profiles
- DNS-over-HTTPS (via systemd-resolved)
- MAC address randomization

---

## System Snapshots

Mint OS uses **Btrfs + Snapper** for automatic snapshots.

```bash
sudo mint-snapshot          # Interactive menu
sudo mint-snapshot --create "Before big update"
sudo mint-snapshot --list
sudo mint-snapshot --restore 5
```

Snapshots are taken automatically:
- Before every `mint-update`
- Hourly (retained: 10)
- Daily (retained: 7)
- Weekly (retained: 4)

---

## Update the System

```bash
sudo mint-update
```

This automatically:
1. Takes a Btrfs snapshot (so you can roll back)
2. Updates mirrors
3. Runs full system upgrade
4. Updates Flatpaks
5. Shows what changed

---

## Developer Setup

```bash
# Docker
sudo systemctl enable --now docker
sudo usermod -aG docker $USER   # then log out + back in

# Python environment
python -m venv ~/.venv
source ~/.venv/bin/activate

# Rust
rustup default stable

# Node.js (multiple versions via volta)
curl https://get.volta.sh | bash
volta install node
```

---

## Troubleshooting

**Black screen on NVIDIA:** Boot, press `e` on GRUB, add `nomodeset` to kernel line.

**WiFi not working:** Run `sudo mint-driver-manager` to auto-detect drivers.

**System slow after install:** Run `sudo mint-optimizer --performance`.

**Pacman locked:** `sudo rm /var/lib/pacman/db.lck`

**Full diagnostics:** `sudo mint-doctor`
