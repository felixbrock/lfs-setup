#!/bin/bash
# Generated from BLFS 13.0-systemd (x/xorg-server.html) — runs inside chroot as root
# Included book blocks: [1, 2] of 3; '&&' chains split into plain statements
# tier-2 rebuild: book-default -D glamor=true and glx (default true) restored; -D secure-rpc=false added per plan (libtirpc not installed); xkb_output_dir kept; skipped: 0 (optional TearFree patch)
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xorg-server-21.1.23
tar -xf xorg-server-21.1.23.tar.xz
cd xorg-server-21.1.23

mkdir build
cd    build

meson setup ..              \
      --prefix=$XORG_PREFIX \
      --localstatedir=/var  \
      -D glamor=true        \
      -D secure-rpc=false   \
      -D xkb_output_dir=/var/lib/xkb
ninja

ninja install
mkdir -pv /etc/X11/xorg.conf.d

cd /sources/blfs
rm -rf xorg-server-21.1.23
echo "### 305-xorg-server-rebuild: complete"
