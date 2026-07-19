#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (libxcrypt) — runs inside chroot
# Included book blocks: [0, 1, 2, 4] of 6; tolerant: []
set -euo pipefail
cd /sources
rm -rf libxcrypt-4.5.2
tar -xf libxcrypt-4.5.2.tar.xz
cd libxcrypt-4.5.2

sed -i '/strchr/s/const//' lib/crypt-{sm3,gost}-yescrypt.c

./configure --prefix=/usr                \
            --enable-hashes=strong,glibc \
            --enable-obsolete-api=no     \
            --disable-static             \
            --disable-failure-tokens

make

make install

cd /sources
rm -rf libxcrypt-4.5.2
echo "### 260-libxcrypt: complete"
