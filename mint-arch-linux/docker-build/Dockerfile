FROM archlinux:latest

LABEL maintainer="Mint Arch Linux Team"
LABEL description="Mint Arch Linux ISO Builder — runs on any machine with Docker"
LABEL version="2.0"

# Update keyring first, then install build dependencies
RUN pacman -Sy --noconfirm archlinux-keyring && \
    pacman -Su --noconfirm && \
    pacman -S --noconfirm --needed \
        archiso \
        dosfstools \
        e2fsprogs \
        libisoburn \
        squashfs-tools \
        mtools \
        grub \
        efibootmgr \
        syslinux \
        curl \
        wget \
        git \
        rsync \
        imagemagick \
        perl-image-exiftool \
        plymouth \
    && pacman -Scc --noconfirm

# Create build & output directories
WORKDIR /build
RUN mkdir -p /output /build/mint-arch-linux/build-logs

# Copy the Mint Arch Linux profile into the container
COPY .. /build/mint-arch-linux/

# Set execute permissions on all scripts
RUN find /build/mint-arch-linux/airootfs/usr/local/bin/ -name "mint-*" -exec chmod +x {} \; && \
    chmod +x /build/mint-arch-linux/build.sh && \
    chmod 440 /build/mint-arch-linux/airootfs/etc/sudoers.d/mintarch 2>/dev/null || true && \
    chmod 400 /build/mint-arch-linux/airootfs/etc/shadow 2>/dev/null || true

# Install Plymouth theme
RUN if [ -d /build/mint-arch-linux/airootfs/usr/share/mint-arch/plymouth-theme ]; then \
        mkdir -p /usr/share/plymouth/themes/mintarch && \
        cp -r /build/mint-arch-linux/airootfs/usr/share/mint-arch/plymouth-theme/. \
              /usr/share/plymouth/themes/mintarch/ && \
        if [ -f /build/mint-arch-linux/airootfs/usr/share/pixmaps/mintarch-logo.png ]; then \
            cp /build/mint-arch-linux/airootfs/usr/share/pixmaps/mintarch-logo.png \
               /usr/share/plymouth/themes/mintarch/logo.png; \
        fi; \
        convert -size 1920x1080 gradient:'#0a0f0a-#0d160d' \
            /usr/share/plymouth/themes/mintarch/background.png 2>/dev/null || true; \
    fi

# Install GRUB theme
RUN if [ -d /build/mint-arch-linux/grub/themes/mint ]; then \
        mkdir -p /usr/share/grub/themes/mint && \
        cp -r /build/mint-arch-linux/grub/themes/mint/. /usr/share/grub/themes/mint/ && \
        if [ -f /build/mint-arch-linux/airootfs/usr/share/pixmaps/mintarch-logo.png ]; then \
            cp /build/mint-arch-linux/airootfs/usr/share/pixmaps/mintarch-logo.png \
               /usr/share/grub/themes/mint/logo.png; \
        fi; \
        convert -size 1920x1080 gradient:'#0a0f0a-#0d160d' \
            /usr/share/grub/themes/mint/background.png 2>/dev/null || true; \
    fi

VOLUME ["/output"]

ENTRYPOINT ["/bin/bash", "-c", \
    "echo '=== Mint Arch Linux Docker Builder ===' && \
     cd /build/mint-arch-linux && \
     ./build.sh --output /output && \
     echo '' && \
     echo '=== Build complete! ISO is in the output/ folder ==='"]
