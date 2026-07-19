#!/bin/bash
# Generated from BLFS 13.0-systemd (general/libxkbcommon.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
cd /sources/blfs
rm -rf libxkbcommon-1.13.1
tar -xf libxkbcommon-1.13.1.tar.gz
cd libxkbcommon-1.13.1

mkdir build
cd    build

meson setup ..                  \
      --prefix=/usr             \
      --buildtype=release       \
      -D enable-docs=false      \
      -D enable-wayland=false
ninja

ninja install

cd /sources/blfs
rm -rf libxkbcommon-1.13.1
echo "### 113-libxkbcommon: complete"
