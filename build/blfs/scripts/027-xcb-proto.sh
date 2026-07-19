#!/bin/bash
# Generated from BLFS 13.0-systemd (x/xcb-proto.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 3
# skipped: 2 (upgrade-from-1.15-only cleanup)
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xcb-proto-1.17.0
tar -xf xcb-proto-1.17.0.tar.xz
cd xcb-proto-1.17.0

PYTHON=python3 ./configure $XORG_CONFIG

make install

cd /sources/blfs
rm -rf xcb-proto-1.17.0
echo "### 027-xcb-proto: complete"
