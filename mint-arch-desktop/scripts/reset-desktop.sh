#!/usr/bin/env bash
# Mint Arch Linux — Reset VM (deletes virtual disk, keeps ISO)
echo 'This will delete the virtual disk and all installed data.'
read -p 'Are you sure? (y/N) ' confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    pkill -f 'qemu-system-x86_64' 2>/dev/null || true
    pkill -f 'websockify' 2>/dev/null || true
    rm -f /vm/mintarch-disk.qcow2 /vm/OVMF_VARS.fd
    echo 'Virtual disk deleted. Run start-vm.sh to start fresh.'
else
    echo 'Reset cancelled.'
fi
