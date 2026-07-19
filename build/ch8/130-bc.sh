#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (bc) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf bc-7.0.3
tar -xf bc-7.0.3.tar.xz
cd bc-7.0.3

CC='gcc -std=c99' ./configure --prefix=/usr -G -O3 -r

make

make install

cd /sources
rm -rf bc-7.0.3
echo "### 130-bc: complete"
