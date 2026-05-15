# Building Mint Arch Linux with Docker

This folder contains a Docker-based builder that creates a real bootable Mint Arch Linux ISO on **any machine** — Windows, macOS, or Linux.

## Requirements

- [Docker Desktop](https://docs.docker.com/get-docker/) installed and running
- ~15GB free disk space
- Internet connection (downloads Arch Linux packages during build)

## Build Steps

### Linux / macOS

```bash
cd mint-arch-linux/docker-build
chmod +x build.sh
./build.sh
```

### Windows (PowerShell)

```powershell
cd mint-arch-linux\docker-build
docker build -t mintarch-builder -f Dockerfile ..
docker run --privileged -v "${PWD}\..\output:/output" mintarch-builder
```

The ISO will appear in `mint-arch-linux/output/mintarch-YYYY.MM.DD-x86_64.iso`

## How long does it take?

| Connection | Time |
|---|---|
| Fast (100Mbps+) | ~20–30 minutes |
| Average (20Mbps) | ~45–60 minutes |
| Slow (<10Mbps) | 60–90 minutes |

## Using in VirtualBox

1. Open VirtualBox → **New**
2. Name: `Mint Arch Linux`, Type: `Linux`, Version: `Arch Linux (64-bit)`
3. RAM: `4096 MB` or more
4. Create a virtual hard disk: `40 GB`
5. After VM is created: **Settings → System → Enable EFI** ✓
6. **Settings → Storage** → Click the optical drive → attach the ISO
7. Start the VM
8. Log in: username `mint`, password `mint`
9. Open terminal, run: `sudo mint-installer`
10. Follow the guided installer to install to the virtual disk

## Using on Real Hardware / USB

```bash
# Linux/macOS — replace sdX with your USB drive
sudo dd if=output/mintarch-*.iso of=/dev/sdX bs=4M status=progress oflag=sync

# Or use balenaEtcher (Windows/macOS/Linux GUI)
# https://etcher.balena.io
```
