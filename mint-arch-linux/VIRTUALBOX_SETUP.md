# Mint OS — VirtualBox Setup Guide

## Step 1: Build the ISO

You need to build the ISO first. See `docker-build/README.md` for instructions.
The ISO will be in `output/mintos-YYYY.MM.DD-x86_64.iso`.

---

## Step 2: Create a VirtualBox VM

1. Open **VirtualBox** → Click **New**
2. Fill in:
   - **Name:** `Mint OS`
   - **Type:** `Linux`
   - **Version:** `Arch Linux (64-bit)`
3. Click **Next**

### Memory
- Set RAM to **4096 MB** (4GB) minimum
- 8GB+ recommended for security tools

### Hard Disk
- Create a new virtual hard disk
- Type: **VDI** (VirtualBox Disk Image)
- Storage: **Dynamically allocated**
- Size: **40 GB** minimum (60GB+ recommended)

---

## Step 3: Configure VM Settings

After creating the VM, go to **Settings**:

### System → Motherboard
- ✅ Enable **EFI (special OSes only)**
- Boot Order: Optical → Hard Disk

### System → Processor
- Processors: **2+** (4 recommended)
- Enable **PAE/NX**

### Display
- Video Memory: **128 MB**
- ✅ Enable **3D Acceleration** (optional but better performance)
- Graphics Controller: **VMSVGA**

### Storage
- Click the **optical drive** (disc icon with "Empty")
- Click the small disc icon on the right → **Choose a disk file**
- Browse to your `mintos-YYYY.MM.DD-x86_64.iso` file

### Network
- Adapter 1: **NAT** (internet access from VM)

---

## Step 4: Boot and Install

1. Start the VM — it will boot into the Mint OS live environment
2. Log in:
   - Username: `mint`
   - Password: `mint`
3. KDE Plasma desktop will load
4. Open **Konsole** (terminal)
5. Run the installer:
   ```bash
   sudo mint-installer
   ```
6. Follow the guided prompts:
   - Select your virtual disk (`/dev/sda`)
   - Choose filesystem (Btrfs recommended)
   - Set username + password
   - Let it install (~10–15 minutes)
   - Reboot when prompted

7. After reboot, remove the ISO:
   - VirtualBox menu: **Devices → Optical Drives → Remove disk from virtual drive**

---

## Step 5: Post-Install (First Boot)

After booting into your installed Mint OS:

```bash
# Install security tools
sudo mint-tools-setup

# Set up AUR helper
mint-setup-aur

# Run system health check
sudo mint-health

# Harden privacy
sudo mint-privacy
```

---

## VirtualBox Guest Additions

Mint OS includes VirtualBox guest utilities pre-installed. If the screen doesn't auto-resize:

```bash
sudo systemctl enable --now vboxservice
sudo usermod -aG vboxsf $USER
```

Then reboot.

---

## Troubleshooting

| Problem | Solution |
|---|---|
| Black screen at boot | Go to Display settings → change Graphics Controller to **VBoxSVGA** |
| Boot fails | Make sure EFI is enabled in System → Motherboard |
| Slow performance | Increase RAM to 8GB, enable 3D acceleration |
| No internet | Check Network is set to **NAT** |
| Screen won't resize | Install VirtualBox Guest Additions (above) |
