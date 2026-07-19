#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (gzip) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf gzip-1.14
tar -xf gzip-1.14.tar.xz
cd gzip-1.14

./configure --prefix=/usr

make

make install

cd /sources
rm -rf gzip-1.14
echo "### 650-gzip: complete"
