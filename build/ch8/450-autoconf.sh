#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (autoconf) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf autoconf-2.72
tar -xf autoconf-2.72.tar.xz
cd autoconf-2.72

./configure --prefix=/usr

make

make install

cd /sources
rm -rf autoconf-2.72
echo "### 450-autoconf: complete"
