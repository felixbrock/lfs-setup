#!/bin/bash
# Generated from BLFS 13.0-systemd (x/util-macros.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf util-macros-1.20.2
tar -xf util-macros-1.20.2.tar.xz
cd util-macros-1.20.2

./configure $XORG_CONFIG

make install

cd /sources/blfs
rm -rf util-macros-1.20.2
echo "### 023-util-macros: complete"
