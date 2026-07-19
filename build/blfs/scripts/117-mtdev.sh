#!/bin/bash
# Generated from BLFS 13.0-systemd (general/mtdev.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
cd /sources/blfs
rm -rf mtdev-1.1.7
tar -xf mtdev-1.1.7.tar.bz2
cd mtdev-1.1.7

./configure --prefix=/usr --disable-static
make

make install

cd /sources/blfs
rm -rf mtdev-1.1.7
echo "### 117-mtdev: complete"
