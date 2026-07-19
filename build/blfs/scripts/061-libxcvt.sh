#!/bin/bash
# Generated from BLFS 13.0-systemd (x/libxcvt.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf libxcvt-0.1.3
tar -xf libxcvt-0.1.3.tar.xz
cd libxcvt-0.1.3

mkdir build
cd    build

meson setup --prefix=$XORG_PREFIX --buildtype=release ..
ninja

ninja install

cd /sources/blfs
rm -rf libxcvt-0.1.3
echo "### 061-libxcvt: complete"
