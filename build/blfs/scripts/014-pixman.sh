#!/bin/bash
# Generated from BLFS 13.0-systemd (general/pixman.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
cd /sources/blfs
rm -rf pixman-0.46.4
tar -xf pixman-0.46.4.tar.gz
cd pixman-0.46.4

mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

cd /sources/blfs
rm -rf pixman-0.46.4
echo "### 014-pixman: complete"
