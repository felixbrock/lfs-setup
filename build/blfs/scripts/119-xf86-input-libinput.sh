#!/bin/bash
# Generated from BLFS 13.0-systemd (x/x7driver.html) — runs inside chroot as root
# Included book blocks: [7, 8] of 13
# Xorg Libinput Driver section of the Xorg input drivers page
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xf86-input-libinput-1.5.0
tar -xf xf86-input-libinput-1.5.0.tar.xz
cd xf86-input-libinput-1.5.0

./configure $XORG_CONFIG
make

make install

cd /sources/blfs
rm -rf xf86-input-libinput-1.5.0
echo "### 119-xf86-input-libinput: complete"
