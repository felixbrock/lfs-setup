#!/bin/bash
# Generated from BLFS 13.0-systemd (x/xbitmaps.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xbitmaps-1.1.3
tar -xf xbitmaps-1.1.3.tar.xz
cd xbitmaps-1.1.3

./configure $XORG_CONFIG

make install

cd /sources/blfs
rm -rf xbitmaps-1.1.3
echo "### 069-xbitmaps: complete"
