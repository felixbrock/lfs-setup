#!/bin/bash
# Generated from BLFS 13.0-systemd (x/luit.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf luit-20250912
tar -xf luit-20250912.tgz
cd luit-20250912

./configure $XORG_CONFIG
make

make install

cd /sources/blfs
rm -rf luit-20250912
echo "### 128-luit: complete"
