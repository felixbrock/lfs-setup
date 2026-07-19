#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (patch) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf patch-2.8
tar -xf patch-2.8.tar.xz
cd patch-2.8

./configure --prefix=/usr

make

make install

cd /sources
rm -rf patch-2.8
echo "### 700-patch: complete"
