#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (findutils) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf findutils-4.10.0
tar -xf findutils-4.10.0.tar.xz
cd findutils-4.10.0

./configure --prefix=/usr --localstatedir=/var/lib/locate

make

make install

cd /sources
rm -rf findutils-4.10.0
echo "### 620-findutils: complete"
