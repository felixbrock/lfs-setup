#!/bin/bash
# Generated from BLFS 13.0-systemd (multimedia/libsndfile.html) — runs inside chroot as root
# Included book blocks: [0, 1, 3] of 4
# skipped: 2 (test suite tweak)
set -euo pipefail
cd /sources/blfs
rm -rf libsndfile-1.2.2
tar -xf libsndfile-1.2.2.tar.xz
cd libsndfile-1.2.2

sed -i '/typedef enum/,/bool ;/d' src/ALAC/alac_{en,de}coder.c

./configure --prefix=/usr    \
            --docdir=/usr/share/doc/libsndfile-1.2.2
make

make install

cd /sources/blfs
rm -rf libsndfile-1.2.2
echo "### 021-libsndfile: complete"
