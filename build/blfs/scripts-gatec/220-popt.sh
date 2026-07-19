#!/bin/bash
# Generated from BLFS 13.0-systemd (general/popt.html) — runs inside chroot as root
# Included book blocks: [0, 2] of 4; '&&' chains split into plain statements
# skipped: 1+3 (doxygen docs)
set -euo pipefail
cd /sources/blfs
rm -rf popt-1.19
tar -xf popt-1.19.tar.gz
cd popt-1.19

./configure --prefix=/usr --disable-static
make

make install

cd /sources/blfs
rm -rf popt-1.19
echo "### 220-popt: complete"
