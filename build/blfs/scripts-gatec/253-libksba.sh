#!/bin/bash
# Generated from BLFS 13.0-systemd (general/libksba.html) — runs as root
# inside the chroot or on the live LFS system (gnupg batch, 2026-07-17).
# Included book blocks: [0, 1] of 2; '&&' chains split
set -euo pipefail
cd /sources/blfs
rm -rf libksba-1.6.7
tar -xf libksba-1.6.7.tar.bz2
cd libksba-1.6.7

./configure --prefix=/usr
make

make install

cd /sources/blfs
rm -rf libksba-1.6.7
echo "### 253-libksba: complete"
