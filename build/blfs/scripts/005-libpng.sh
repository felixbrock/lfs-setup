#!/bin/bash
# Generated from BLFS 13.0-systemd (general/libpng.html) — runs inside chroot as root
# Included book blocks: [1, 2] of 3
# skipped: 0 (optional apng patch)
set -euo pipefail
cd /sources/blfs
rm -rf libpng-1.6.58
tar -xf libpng-1.6.58.tar.xz
cd libpng-1.6.58

./configure --prefix=/usr --disable-static
make

make install
mkdir -v /usr/share/doc/libpng-1.6.58
cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.58

cd /sources/blfs
rm -rf libpng-1.6.58
echo "### 005-libpng: complete"
