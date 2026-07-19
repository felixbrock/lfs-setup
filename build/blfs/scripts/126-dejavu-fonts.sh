#!/bin/bash
# Generated from BLFS 13.0-systemd (x/TTF-and-OTF-fonts.html) — runs inside chroot as root
# Included book blocks: [0] of 1
# dejavu install block from the TTF-and-OTF fonts page
set -euo pipefail
cd /sources/blfs
rm -rf dejavu-fonts-ttf-2.37
tar -xf dejavu-fonts-ttf-2.37.tar.bz2
cd dejavu-fonts-ttf-2.37

install -v -d -m755 /usr/share/fonts/dejavu
install -v -m644 ttf/*.ttf /usr/share/fonts/dejavu
fc-cache -v /usr/share/fonts/dejavu

cd /sources/blfs
rm -rf dejavu-fonts-ttf-2.37
echo "### 126-dejavu-fonts: complete"
