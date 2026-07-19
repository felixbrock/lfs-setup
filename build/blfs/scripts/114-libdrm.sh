#!/bin/bash
# Generated from BLFS 13.0-systemd (x/libdrm.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf libdrm-2.4.131
tar -xf libdrm-2.4.131.tar.xz
cd libdrm-2.4.131

mkdir build
cd    build

meson setup --prefix=$XORG_PREFIX \
            --buildtype=release   \
            -D udev=true          \
            -D valgrind=disabled  \
            ..
ninja

ninja install

cd /sources/blfs
rm -rf libdrm-2.4.131
echo "### 114-libdrm: complete"
