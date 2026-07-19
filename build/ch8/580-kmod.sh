#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (kmod) — runs inside chroot
# Included book blocks: [0, 1, 2] of 3; tolerant: []
set -euo pipefail
cd /sources
rm -rf kmod-34.2
tar -xf kmod-34.2.tar.xz
cd kmod-34.2

mkdir -p build
cd       build

meson setup --prefix=/usr ..    \
            --buildtype=release \
            -D manpages=false

ninja

ninja install

cd /sources
rm -rf kmod-34.2
echo "### 580-kmod: complete"
