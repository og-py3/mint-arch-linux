#!/usr/bin/env bash
# =============================================================================
# Mint Arch Linux — profiledef.sh  |  archiso profile definition
# =============================================================================

iso_name="mintarch"
iso_label="MINTARCH_$(date +%Y%m)"
iso_publisher="Mint Arch Linux <https://github.com/mint-arch-linux>"
iso_application="Mint Arch Linux — Rolling Linux | KDE Plasma | Security"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=(
    'bios.syslinux'
    'uefi.systemd-boot'
)
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '19' '-b' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')

file_permissions=(
  # System security files
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/etc/sudoers.d/mint"]="0:0:440"

  # Mint Arch Linux CLI tools
  ["/usr/local/bin/mint-installer"]="0:0:755"
  ["/usr/local/bin/mint-firstboot"]="0:0:755"
  ["/usr/local/bin/mint-tools-setup"]="0:0:755"
  ["/usr/local/bin/mint-update"]="0:0:755"
  ["/usr/local/bin/mint-hardware"]="0:0:755"
  ["/usr/local/bin/mint-privacy"]="0:0:755"
  ["/usr/local/bin/mint-health"]="0:0:755"
  ["/usr/local/bin/mint-snapshot"]="0:0:755"
  ["/usr/local/bin/mint-gaming"]="0:0:755"
  ["/usr/local/bin/mint-setup-aur"]="0:0:755"
  ["/usr/local/bin/mint-fetch"]="0:0:755"
  ["/usr/local/bin/mint-clean"]="0:0:755"
  ["/usr/local/bin/mint-doctor"]="0:0:755"
  ["/usr/local/bin/mint-backup"]="0:0:755"
  ["/usr/local/bin/mint-optimizer"]="0:0:755"
  ["/usr/local/bin/mint-driver-manager"]="0:0:755"
  ["/usr/local/bin/mint-welcome"]="0:0:755"
  ["/usr/local/bin/mint-zram-init"]="0:0:755"

  # Branding assets
  ["/usr/share/pixmaps/mintarch-logo.png"]="0:0:644"
  ["/usr/share/mint-arch/logo.png"]="0:0:644"

  # Plymouth theme
  ["/usr/share/mint-arch/plymouth-theme/mintarch.script"]="0:0:644"
  ["/usr/share/mint-arch/plymouth-theme/mintarch.plymouth"]="0:0:644"
)
