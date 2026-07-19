#!/bin/bash
# Generated from BLFS 13.0-systemd (general/libusb.html) — runs inside chroot as root
# Included book blocks: [0, 2] of 4; '&&' chains split into plain statements
# skipped: 1+3 (doxygen docs)
set -euo pipefail
cd /sources/blfs
rm -rf libusb-1.0.29
tar -xf libusb-1.0.29.tar.bz2
cd libusb-1.0.29

./configure --prefix=/usr --disable-static
make

make install

cd /sources/blfs
rm -rf libusb-1.0.29
echo "### 223-libusb: complete"
