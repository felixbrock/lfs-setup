#!/bin/bash
# Generated from BLFS 13.0-systemd (x/xcb-util.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xcb-util-0.4.1
tar -xf xcb-util-0.4.1.tar.xz
cd xcb-util-0.4.1

./configure $XORG_CONFIG
make

make install

cd /sources/blfs
rm -rf xcb-util-0.4.1
echo "### 062-xcb-util: complete"
