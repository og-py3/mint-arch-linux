#!/usr/bin/env bash
# Mint Arch Linux — Package installation inside the VM
# This script is not applicable for the QEMU VM desktop.
# To install packages, open the terminal INSIDE the VM and run:
#   sudo pacman -S <package>
# Or run: sudo mint-tools-setup
echo "Packages are installed INSIDE the VM, not from the host."
echo "Open the terminal in the Mint Arch Linux VM and run:"
echo "  sudo pacman -S $*"
echo "Or use: sudo mint-tools-setup"
