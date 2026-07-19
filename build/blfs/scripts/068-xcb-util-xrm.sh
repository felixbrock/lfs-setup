#!/bin/bash
# upstream, not in BLFS — autotools (release tarball ships configure) — runs inside chroot as root
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xcb-util-xrm-1.3
tar -xf xcb-util-xrm-1.3.tar.bz2
cd xcb-util-xrm-1.3

./configure $XORG_CONFIG
make

make install

cd /sources/blfs
rm -rf xcb-util-xrm-1.3
echo "### 068-xcb-util-xrm: complete"
