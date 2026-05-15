FROM lscr.io/linuxserver/webtop:arch-kde

LABEL maintainer="Mint Arch Linux"
LABEL description="Mint Arch Linux — Browser-accessible KDE Desktop via port 3000"

# Install Mint Arch Linux tools and packages
RUN pacman -Sy --noconfirm archlinux-keyring && \
    pacman -Su --noconfirm && \
    pacman -S --noconfirm --needed \
        zsh \
        zsh-autosuggestions \
        zsh-syntax-highlighting \
        zsh-completions \
        starship \
        fastfetch \
        btop \
        htop \
        neovim \
        vim \
        git \
        curl \
        wget \
        rsync \
        unzip \
        p7zip \
        ufw \
        apparmor \
        btrfs-progs \
        snapper \
        reflector \
        pacman-contrib \
        noto-fonts \
        noto-fonts-emoji \
        ttf-jetbrains-mono-nerd \
        ttf-hack-nerd \
        ttf-font-awesome \
        python \
        python-pip \
        base-devel \
        networkmanager \
        flatpak \
    && pacman -Scc --noconfirm

# Copy Mint Arch Linux branding & tools
COPY airootfs/usr/local/bin/mint-* /usr/local/bin/
COPY airootfs/usr/local/share/mint-os/ /usr/local/share/mint-arch/
COPY airootfs/etc/motd /etc/motd
COPY airootfs/etc/os-release /etc/os-release
COPY airootfs/etc/skel/.zshrc /root/.zshrc
COPY airootfs/usr/share/mint-os/fastfetch.jsonc /etc/fastfetch.jsonc
COPY airootfs/usr/share/mint-os/starship.toml /etc/starship.toml

# Set permissions on all mint-* tools
RUN chmod +x /usr/local/bin/mint-* 2>/dev/null || true

# Set zsh as default shell
RUN chsh -s /usr/bin/zsh root 2>/dev/null || true

# Copy KDE theme assets
COPY airootfs/usr/share/kvantum/MintOS/ /usr/share/kvantum/MintArch/
COPY airootfs/usr/share/color-schemes/MintOSDark.colors /usr/share/color-schemes/MintArchDark.colors
COPY airootfs/usr/share/konsole/MintOS.profile /usr/share/konsole/MintArch.profile
COPY airootfs/usr/share/konsole/MintOSDark.colorscheme /usr/share/konsole/MintArchDark.colorscheme

# Setup Flatpak with Flathub
RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true

# Set environment
ENV TITLE="Mint Arch Linux Desktop"
ENV PUID=1000
ENV PGID=1000
ENV TZ=UTC

EXPOSE 3000
