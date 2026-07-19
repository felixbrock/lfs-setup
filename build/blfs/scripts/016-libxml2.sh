#!/bin/bash
# Generated from BLFS 13.0-systemd (general/libxml2.html) — runs inside chroot as root
# Included book blocks: [0, 1, 5, 6] of 7
# skipped: 2 (optional docs), 3+4 (test suite). DEVIATION: -D icu=disabled — ICU (book-recommended) is not in LFS/tier-1
set -euo pipefail
cd /sources/blfs
rm -rf libxml2-2.15.3
tar -xf libxml2-2.15.3.tar.xz
cd libxml2-2.15.3

sed -i "/'git'/,+3d" meson.build

mkdir build
cd    build

meson setup ..           \
      --prefix=/usr      \
      -D history=enabled \
      -D icu=disabled
ninja

ninja install

sed "s/--static/--shared/" -i /usr/bin/xml2-config

cd /sources/blfs
rm -rf libxml2-2.15.3
echo "### 016-libxml2: complete"
