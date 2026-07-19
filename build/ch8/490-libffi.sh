#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (libffi) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf libffi-3.5.2
tar -xf libffi-3.5.2.tar.gz
cd libffi-3.5.2

./configure --prefix=/usr    \
            --disable-static \
            --with-gcc-arch=native

make

make install

cd /sources
rm -rf libffi-3.5.2
echo "### 490-libffi: complete"
