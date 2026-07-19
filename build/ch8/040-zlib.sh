#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (zlib) — runs inside chroot
# Included book blocks: [0, 1, 3, 4] of 5; tolerant: []
set -euo pipefail
cd /sources
rm -rf zlib-1.3.2
tar -xf zlib-1.3.2.tar.gz
cd zlib-1.3.2

./configure --prefix=/usr

make

make install

rm -fv /usr/lib/libz.a

cd /sources
rm -rf zlib-1.3.2
echo "### 040-zlib: complete"
