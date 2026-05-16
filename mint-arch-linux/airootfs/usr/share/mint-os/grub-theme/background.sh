#!/usr/bin/env bash
# Generates a simple dark background for the GRUB theme
# Run this on build to create background.png if ImageMagick is available
if command -v convert &>/dev/null; then
    convert -size 1920x1080 \
        gradient:'#0d1a0d-#0a0a0a' \
        -fill '#0d0d0d' \
        /usr/share/mint-os/grub-theme/background.png
fi
