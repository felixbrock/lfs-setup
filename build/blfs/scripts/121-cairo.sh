#!/bin/bash
# Generated from BLFS 13.0-systemd (x/cairo.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
cd /sources/blfs
rm -rf cairo-1.18.4
tar -xf cairo-1.18.4.tar.xz
cd cairo-1.18.4

mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

cd /sources/blfs
rm -rf cairo-1.18.4
echo "### 121-cairo: complete"
