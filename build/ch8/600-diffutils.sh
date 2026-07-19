#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (diffutils) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf diffutils-3.12
tar -xf diffutils-3.12.tar.xz
cd diffutils-3.12

./configure --prefix=/usr

make

make install

cd /sources
rm -rf diffutils-3.12
echo "### 600-diffutils: complete"
