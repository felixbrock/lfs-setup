#!/bin/bash
# Generated from BLFS 13.0-systemd (x/xkeyboard-config.html) — runs inside chroot as root
# Included book blocks: [0, 2] of 3
# skipped: 1 (upgrade-from-2.44-only cleanup)
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xkeyboard-config-2.46
tar -xf xkeyboard-config-2.46.tar.xz
cd xkeyboard-config-2.46

mkdir build
cd    build

meson setup --prefix=$XORG_PREFIX --buildtype=release ..
ninja

ninja install

cd /sources/blfs
rm -rf xkeyboard-config-2.46
echo "### 112-xkeyboard-config: complete"
