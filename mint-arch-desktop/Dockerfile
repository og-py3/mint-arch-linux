FROM ubuntu:24.04

LABEL maintainer="Mint Arch Linux Team"
LABEL description="Mint Arch Linux — Real ISO booting in QEMU VM, browser-accessible via noVNC"
LABEL version="3.0"

ENV DEBIAN_FRONTEND=noninteractive \
    VM_RAM=2048 \
    VM_CPUS=2 \
    VNC_PORT=5900 \
    NOVNC_PORT=3000 \
    DISK_SIZE=20G \
    ISO_PATH=/vm/mintarch.iso

# Install QEMU, OVMF (UEFI), noVNC, websockify and utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
        qemu-system-x86 \
        qemu-utils \
        ovmf \
        novnc \
        websockify \
        curl \
        wget \
        ca-certificates \
        bash \
        netcat-openbsd \
        python3 \
    && rm -rf /var/lib/apt/lists/*

# Prepare VM workspace
RUN mkdir -p /vm

# Copy the VM startup script
COPY scripts/start-vm.sh /vm/start-vm.sh
RUN chmod +x /vm/start-vm.sh

EXPOSE 3000 5900

CMD ["/vm/start-vm.sh"]
