#!/bin/bash
# Generated from BLFS 13.0-systemd (x/at-spi2-core.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
set -euo pipefail
cd /sources/blfs
rm -rf at-spi2-core-2.58.3
tar -xf at-spi2-core-2.58.3.tar.xz
cd at-spi2-core-2.58.3

mkdir build
cd    build

meson setup ..                  \
      --prefix=/usr             \
      --buildtype=release       \
      -D gtk2_atk_adaptor=false
ninja

ninja install

cd /sources/blfs
rm -rf at-spi2-core-2.58.3
echo "### 308-at-spi2-core: complete"
