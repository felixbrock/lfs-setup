#!/bin/bash
# Generated from BLFS 13.0-systemd (x/hicolor-icon-theme.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
set -euo pipefail
cd /sources/blfs
rm -rf hicolor-icon-theme-0.18
tar -xf hicolor-icon-theme-0.18.tar.xz
cd hicolor-icon-theme-0.18

mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

cd /sources/blfs
rm -rf hicolor-icon-theme-0.18
echo "### 309-hicolor-icon-theme: complete"
