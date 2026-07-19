#!/bin/bash
# Generated from BLFS 13.0-systemd (general/fribidi.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
cd /sources/blfs
rm -rf fribidi-1.0.16
tar -xf fribidi-1.0.16.tar.xz
cd fribidi-1.0.16

mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

cd /sources/blfs
rm -rf fribidi-1.0.16
echo "### 015-fribidi: complete"
