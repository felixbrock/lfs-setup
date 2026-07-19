#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (xz) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf xz-5.8.3
tar -xf xz-5.8.3.tar.xz
cd xz-5.8.3

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.8.3

make

make install

cd /sources
rm -rf xz-5.8.3
echo "### 060-xz: complete"
