#!/bin/bash
# Generated from BLFS 13.0-systemd (x/x7driver.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 13
# libevdev section of the Xorg input drivers page
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf libevdev-1.13.6
tar -xf libevdev-1.13.6.tar.xz
cd libevdev-1.13.6

mkdir build
cd    build

meson setup ..                  \
      --prefix=$XORG_PREFIX     \
      --buildtype=release       \
      -D documentation=disabled \
      -D tests=disabled
ninja

ninja install

cd /sources/blfs
rm -rf libevdev-1.13.6
echo "### 116-libevdev: complete"
