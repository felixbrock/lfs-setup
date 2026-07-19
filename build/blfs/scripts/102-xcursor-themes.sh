#!/bin/bash
# Generated from BLFS 13.0-systemd (x/xcursor-themes.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
cd /sources/blfs
rm -rf xcursor-themes-1.0.7
tar -xf xcursor-themes-1.0.7.tar.xz
cd xcursor-themes-1.0.7

./configure --prefix=/usr
make

make install

cd /sources/blfs
rm -rf xcursor-themes-1.0.7
echo "### 102-xcursor-themes: complete"
