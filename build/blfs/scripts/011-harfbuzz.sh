#!/bin/bash
# Generated from BLFS 13.0-systemd (general/harfbuzz.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
cd /sources/blfs
rm -rf harfbuzz-12.3.2
tar -xf harfbuzz-12.3.2.tar.xz
cd harfbuzz-12.3.2

mkdir build
cd    build

meson setup ..             \
      --prefix=/usr        \
      --buildtype=release  \
      -D graphite2=enabled
ninja

ninja install

cd /sources/blfs
rm -rf harfbuzz-12.3.2
echo "### 011-harfbuzz: complete"
