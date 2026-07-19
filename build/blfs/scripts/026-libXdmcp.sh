#!/bin/bash
# Generated from BLFS 13.0-systemd (x/libXdmcp.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf libXdmcp-1.1.5
tar -xf libXdmcp-1.1.5.tar.xz
cd libXdmcp-1.1.5

./configure $XORG_CONFIG --docdir='${datadir}'/doc/libXdmcp-1.1.5
make

make install

cd /sources/blfs
rm -rf libXdmcp-1.1.5
echo "### 026-libXdmcp: complete"
