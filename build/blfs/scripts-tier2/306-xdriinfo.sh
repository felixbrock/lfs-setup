#!/bin/bash
# Generated from BLFS 13.0-systemd (x/x7app.html) — runs inside chroot as root
# deferred from the 070 Xorg apps group (needs Mesa GL); built with the page loop body
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xdriinfo-1.0.8
tar -xf xdriinfo-1.0.8.tar.xz
cd xdriinfo-1.0.8

./configure $XORG_CONFIG
make

make install

cd /sources/blfs
rm -rf xdriinfo-1.0.8
echo "### 306-xdriinfo: complete"
