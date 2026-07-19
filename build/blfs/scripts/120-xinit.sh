#!/bin/bash
# Generated from BLFS 13.0-systemd (x/xinit.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xinit-1.4.4
tar -xf xinit-1.4.4.tar.xz
cd xinit-1.4.4

./configure $XORG_CONFIG --with-xinitdir=/etc/X11/app-defaults
make

make install
ldconfig

cd /sources/blfs
rm -rf xinit-1.4.4
echo "### 120-xinit: complete"
