#!/bin/bash
# Generated from BLFS 13.0-systemd (general/usbutils.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
set -euo pipefail
cd /sources/blfs
rm -rf usbutils-019
tar -xf usbutils-019.tar.xz
cd usbutils-019

mkdir build
cd    build

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release

ninja

ninja install

cd /sources/blfs
rm -rf usbutils-019
echo "### 225-usbutils: complete"
