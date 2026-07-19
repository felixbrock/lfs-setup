#!/bin/bash
# Generated from BLFS 13.0-systemd (general/libassuan.html) — runs as root
# inside the chroot or on the live LFS system (gnupg batch, 2026-07-17).
# Included book blocks: [0, 2] of 3 minus makeinfo/html doc build + installs
# that depend on it (block 1 = pdf docs, skipped); '&&' chains split
set -euo pipefail
cd /sources/blfs
rm -rf libassuan-3.0.2
tar -xf libassuan-3.0.2.tar.bz2
cd libassuan-3.0.2

./configure --prefix=/usr
make

make install

cd /sources/blfs
rm -rf libassuan-3.0.2
echo "### 252-libassuan: complete"
