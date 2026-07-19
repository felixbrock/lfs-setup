#!/bin/bash
# Generated from BLFS 13.0-systemd (x/x7font.html) — runs inside chroot as root
# Build commands from the page loop body
# needed before xorg-server; built from the x7font loop body (also rebuilt harmlessly by the 104 group, whose manifest is kept verbatim)
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf font-util-1.4.1
tar -xf font-util-1.4.1.tar.xz
cd font-util-1.4.1

./configure $XORG_CONFIG
make

make install

cd /sources/blfs
rm -rf font-util-1.4.1
echo "### 103-font-util: complete"
