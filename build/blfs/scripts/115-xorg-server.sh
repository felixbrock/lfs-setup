#!/bin/bash
# Generated from BLFS 13.0-systemd (x/xorg-server.html) — runs inside chroot as root
# Included book blocks: [1, 2] of 3
# TIER1 overrides per package list: -D glamor=false (xkb_output_dir already in book block). DEVIATION: added -D glx=false — GLX requires Mesa (gl.pc), which is tier 2; skipped: 0 (optional TearFree backport patch, not downloaded)
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xorg-server-21.1.23
tar -xf xorg-server-21.1.23.tar.xz
cd xorg-server-21.1.23

mkdir build
cd    build

# -D secure-rpc=false: needs libtirpc (not in tier 1); only used by
# XDM-AUTHORIZATION-1, irrelevant for startx/i3
meson setup ..              \
      --prefix=$XORG_PREFIX \
      --localstatedir=/var  \
      -D glamor=false        \
      -D glx=false          \
      -D secure-rpc=false   \
      -D xkb_output_dir=/var/lib/xkb
ninja

ninja install
mkdir -pv /etc/X11/xorg.conf.d

cd /sources/blfs
rm -rf xorg-server-21.1.23
echo "### 115-xorg-server: complete"
