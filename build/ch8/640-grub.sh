#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (grub) — runs inside chroot
# Included book blocks: [0, 1, 2, 3, 4] of 5; tolerant: []
set -euo pipefail
cd /sources
rm -rf grub-2.14
tar -xf grub-2.14.tar.xz
cd grub-2.14

unset {C,CPP,CXX,LD}FLAGS

sed 's/--image-base/--nonexist-linker-option/' -i configure

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-efiemu  \
            --disable-werror

make

make install

cd /sources
rm -rf grub-2.14
echo "### 640-grub: complete"
