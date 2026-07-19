#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (make) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf make-4.4.1
tar -xf make-4.4.1.tar.gz
cd make-4.4.1

./configure --prefix=/usr

make

make install

cd /sources
rm -rf make-4.4.1
echo "### 690-make: complete"
