#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (automake) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf automake-1.18.1
tar -xf automake-1.18.1.tar.xz
cd automake-1.18.1

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.18.1

make

make install

cd /sources
rm -rf automake-1.18.1
echo "### 460-automake: complete"
