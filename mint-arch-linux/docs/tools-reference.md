# Mint OS Tools — Complete Reference

## mint-installer
Guided disk installer for bare metal or VM installs.

```bash
sudo mint-installer
```
- Supports Btrfs (recommended) and ext4
- Creates EFI + swap + root partitions automatically
- Installs GRUB with Mint OS theme
- Sets up Plymouth boot animation
- Configures locale, timezone, hostname, user account
- Enables all essential services

---

## mint-update
Safe system updater with automatic Btrfs snapshot before update.

```bash
sudo mint-update           # Full update
sudo mint-update --check   # Check for updates without installing
sudo mint-update --aur     # Include AUR packages (requires paru)
```

---

## mint-doctor
Full system diagnostics — checks everything and reports issues with fix suggestions.

```bash
sudo mint-doctor
```
Checks: network, disk health (SMART), memory, services, security, packages, filesystem, temperatures.

---

## mint-clean
Smart disk space cleaner.

```bash
sudo mint-clean
```
Cleans: pacman cache, orphaned packages, journal logs, /tmp, user cache, old Flatpak runtimes, old Btrfs snapshots.

---

## mint-optimizer
Performance profile manager.

```bash
sudo mint-optimizer               # Interactive
sudo mint-optimizer --balanced    # Default — good for daily use
sudo mint-optimizer --performance # Maximum speed
sudo mint-optimizer --battery     # Save power
sudo mint-optimizer --gaming      # Maximum FPS
sudo mint-optimizer --zram        # Enable compressed RAM swap
sudo mint-optimizer --boot        # Optimize boot time
```

---

## mint-driver-manager
Auto-detects hardware and installs the right drivers.

```bash
sudo mint-driver-manager
```
Handles: NVIDIA (open or proprietary), AMD (AMDGPU), Intel, Broadcom WiFi, Realtek, Bluetooth, VMware/VirtualBox/QEMU guest tools, printers.

---

## mint-backup
Backup manager using rsync + Btrfs snapshots.

```bash
mint-backup                  # Interactive menu
mint-backup --configure      # Set backup destination
mint-backup --run            # Run backup now
mint-backup --snapshot       # Create Btrfs snapshot only
mint-backup --list           # List available backups
```

---

## mint-fetch
System info display (replaces neofetch).

```bash
mint-fetch
```
Shows: OS, kernel, uptime, packages, shell, desktop, CPU, GPU, memory, disk.

---

## mint-health
Live system health dashboard.

```bash
sudo mint-health
```
Real-time: CPU usage, memory, disk, temperature, active services, network.

---

## mint-snapshot
Btrfs snapshot manager powered by Snapper.

```bash
sudo mint-snapshot                        # Interactive
sudo mint-snapshot --create "description"
sudo mint-snapshot --list
sudo mint-snapshot --restore N
sudo mint-snapshot --delete N
```

---

## mint-tools-setup
Security tools manager — install tools by category.

```bash
sudo mint-tools-setup
```
Categories: Network Analysis, Web Security, Password Tools, Forensics, Exploitation, Wireless, Social Engineering, Reverse Engineering, Cryptography, OSINT, Vulnerability Scanning, Malware Analysis, and more.

---

## mint-privacy
Privacy and security hardening wizard.

```bash
sudo mint-privacy
```
Configures: UFW firewall, AppArmor, DNS-over-HTTPS, MAC randomization, secure DNS (Cloudflare/Quad9/NextDNS).

---

## mint-gaming
Gaming mode setup.

```bash
sudo mint-gaming
```
Installs: Steam, Lutris, Wine, Proton, GameMode, MangoHud, Vulkan 32-bit libs, controller support.

---

## mint-hardware
Hardware detection and info.

```bash
sudo mint-hardware
```
Shows: CPU, GPU, memory, storage, network adapters, connected USB devices.

---

## mint-setup-aur
Sets up the paru AUR helper.

```bash
mint-setup-aur
```
Builds paru from AUR. After install, use `paru -S package-name` for AUR packages.

---

## mint-welcome
First-run setup wizard.

```bash
mint-welcome
```
Walks through: update, AUR, security, drivers, tools, gaming. Creates `~/.config/mint-welcomed` when complete so it only runs once.
