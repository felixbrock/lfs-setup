#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (m4) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf m4-1.4.21
tar -xf m4-1.4.21.tar.xz
cd m4-1.4.21

./configure --prefix=/usr

make

make install

cd /sources
rm -rf m4-1.4.21
echo "### 120-m4: complete"
