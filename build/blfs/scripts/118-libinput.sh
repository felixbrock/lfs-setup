#!/bin/bash
# Generated from BLFS 13.0-systemd (x/x7driver.html) — runs inside chroot as root
# Included book blocks: [4, 5] of 13
# libinput section of the Xorg input drivers page; skipped: 6 (optional sphinx docs)
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf libinput-1.31.3
tar -xf libinput-1.31.3.tar.gz
cd libinput-1.31.3

mkdir build
cd    build

meson setup ..              \
      --prefix=$XORG_PREFIX \
      --buildtype=release   \
      -D debug-gui=false    \
      -D tests=false        \
      -D libwacom=false     \
      -D udev-dir=/usr/lib/udev
ninja

ninja install

cd /sources/blfs
rm -rf libinput-1.31.3
echo "### 118-libinput: complete"
