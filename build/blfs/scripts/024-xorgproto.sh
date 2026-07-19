#!/bin/bash
# Generated from BLFS 13.0-systemd (x/xorgproto.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xorgproto-2025.1
tar -xf xorgproto-2025.1.tar.xz
cd xorgproto-2025.1

mkdir build
cd    build

meson setup --prefix=$XORG_PREFIX ..
ninja

ninja install
mv -v $XORG_PREFIX/share/doc/xorgproto{,-2025.1}

cd /sources/blfs
rm -rf xorgproto-2025.1
echo "### 024-xorgproto: complete"
