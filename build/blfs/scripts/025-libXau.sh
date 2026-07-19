#!/bin/bash
# Generated from BLFS 13.0-systemd (x/libXau.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf libXau-1.0.12
tar -xf libXau-1.0.12.tar.xz
cd libXau-1.0.12

./configure $XORG_CONFIG
make

make install

cd /sources/blfs
rm -rf libXau-1.0.12
echo "### 025-libXau: complete"
