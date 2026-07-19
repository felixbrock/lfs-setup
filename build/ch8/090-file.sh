#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (file) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf file-5.46
tar -xf file-5.46.tar.gz
cd file-5.46

./configure --prefix=/usr

make

make install

cd /sources
rm -rf file-5.46
echo "### 090-file: complete"
