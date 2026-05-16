#!/usr/bin/env bash
# Mint Arch Linux — Stop VM
echo 'Stopping Mint Arch Linux VM...'
pkill -f 'qemu-system-x86_64' && echo 'VM stopped.' || echo 'VM was not running.'
pkill -f 'websockify' 2>/dev/null || true
