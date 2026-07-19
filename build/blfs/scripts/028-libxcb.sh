#!/bin/bash
# Generated from BLFS 13.0-systemd (x/libxcb.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 3
# skipped: 2 (chown, only needed for non-root builds)
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf libxcb-1.17.0
tar -xf libxcb-1.17.0.tar.xz
cd libxcb-1.17.0

./configure $XORG_CONFIG      \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.17.0
LC_ALL=en_US.UTF-8 make

make install

cd /sources/blfs
rm -rf libxcb-1.17.0
echo "### 028-libxcb: complete"
