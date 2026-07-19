#!/bin/bash
# Generated from BLFS 13.0-systemd (x/libepoxy.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
set -euo pipefail
cd /sources/blfs
rm -rf libepoxy-1.5.10
tar -xf libepoxy-1.5.10.tar.xz
cd libepoxy-1.5.10

mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

cd /sources/blfs
rm -rf libepoxy-1.5.10
echo "### 304-libepoxy: complete"
