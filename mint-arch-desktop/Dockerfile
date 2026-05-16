FROM lscr.io/linuxserver/webtop:arch-kde

LABEL maintainer="Mint Arch Linux Team"
LABEL description="Mint Arch Linux — Browser-accessible KDE Plasma desktop with live wallpaper"
LABEL version="2025.05"

ENV TITLE="Mint Arch Linux" \
    CUSTOM_USER=mint \
    PASSWORD=mint \
    PUID=1000 \
    PGID=1000 \
    TZ=UTC

# Update system
RUN pacman -Sy --noconfirm archlinux-keyring 2>/dev/null || true && \
    pacman -Su --noconfirm 2>/dev/null || true

# Install all required packages
RUN pacman -S --noconfirm --needed \
        zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions \
        starship fastfetch btop htop neovim vim \
        git curl wget rsync unzip p7zip \
        base-devel python python-pip \
        networkmanager flatpak \
        mpv ffmpeg \
        qt6-multimedia qt6-multimedia-ffmpeg \
        noto-fonts noto-fonts-emoji \
        ttf-jetbrains-mono-nerd ttf-font-awesome \
        nmap wireshark-qt wireshark-cli tcpdump ncat socat \
        proxychains-ng tor sqlmap gobuster ffuf \
        hashcat john hydra aircrack-ng metasploit \
        binwalk exiftool radare2 gdb steghide \
    && pacman -Scc --noconfirm

# Try to install mpvpaper from AUR (best effort)
RUN pacman -S --noconfirm --needed git base-devel 2>/dev/null || true && \
    useradd -m builduser 2>/dev/null || true && \
    echo "builduser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    su builduser -c "git clone https://aur.archlinux.org/mpvpaper.git /tmp/mpvpaper && cd /tmp/mpvpaper && makepkg -si --noconfirm" 2>/dev/null || \
    echo "mpvpaper AUR install skipped (will use mpv fallback)"

# Bootstrap BlackArch repo
RUN curl -fsSL https://blackarch.org/strap.sh -o /tmp/strap.sh && \
    chmod +x /tmp/strap.sh && bash /tmp/strap.sh && rm -f /tmp/strap.sh && \
    pacman -Sy --noconfirm 2>/dev/null || true

# Copy Mint Arch Linux tools
COPY mint-arch-linux/airootfs/usr/local/bin/mint-* /usr/local/bin/
COPY mint-arch-linux/airootfs/etc/motd /etc/motd
COPY mint-arch-linux/airootfs/etc/os-release /etc/os-release
COPY mint-arch-linux/airootfs/etc/skel/.zshrc /root/.zshrc
COPY mint-arch-linux/airootfs/etc/skel/.config/kwinrc /root/.config/kwinrc
COPY mint-arch-linux/airootfs/etc/skel/.config/plasmarc /root/.config/plasmarc
COPY mint-arch-linux/airootfs/usr/share/mint-os/fastfetch.jsonc /etc/fastfetch.jsonc
COPY mint-arch-linux/airootfs/usr/share/mint-os/starship.toml /etc/starship.toml

# Copy live wallpaper video
COPY mint-arch-linux/airootfs/usr/share/mint-arch/wallpapers/mintarch-live-wallpaper.mp4 /usr/share/mint-arch/wallpapers/mintarch-live-wallpaper.mp4

# Copy SDDM theme
COPY mint-arch-linux/airootfs/usr/share/sddm/themes/mint-arch/ /usr/share/sddm/themes/mint-arch/

# KDE theming
COPY mint-arch-linux/airootfs/usr/share/kvantum/MintOS/ /usr/share/kvantum/MintArch/
COPY mint-arch-linux/airootfs/usr/share/color-schemes/MintOSDark.colors /usr/share/color-schemes/MintArchDark.colors
COPY mint-arch-linux/airootfs/usr/share/konsole/MintOS.profile /usr/share/konsole/MintArch.profile
COPY mint-arch-linux/airootfs/usr/share/konsole/MintOSDark.colorscheme /usr/share/konsole/MintArchDark.colorscheme

# Logo
COPY mint-arch-linux/airootfs/usr/share/mint-os/logo.png /usr/share/mint-arch/logo.png
COPY mint-arch-linux/airootfs/usr/share/pixmaps/mintarch-logo.png /usr/share/pixmaps/mintarch-logo.png

# Autostart for live wallpaper
COPY mint-arch-linux/airootfs/etc/skel/.config/autostart/mint-live-wallpaper.desktop /root/.config/autostart/mint-live-wallpaper.desktop

# Set permissions
RUN chmod +x /usr/local/bin/mint-* 2>/dev/null || true && \
    chsh -s /usr/bin/zsh root 2>/dev/null || true && \
    mkdir -p /root/.config/autostart

# Flatpak
RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true

EXPOSE 3000
