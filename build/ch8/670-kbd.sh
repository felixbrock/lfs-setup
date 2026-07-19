#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (kbd) — runs inside chroot
# Included book blocks: [0, 1, 2, 3, 5] of 7; tolerant: []
set -euo pipefail
cd /sources
rm -rf kbd-2.9.0
tar -xf kbd-2.9.0.tar.xz
cd kbd-2.9.0

patch -Np1 -i ../kbd-2.9.0-backspace-1.patch

sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock

make

make install

cd /sources
rm -rf kbd-2.9.0
echo "### 670-kbd: complete"
