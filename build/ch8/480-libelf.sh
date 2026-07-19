#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (libelf) — runs inside chroot
# Included book blocks: [0, 1, 2] of 3; tolerant: []
set -euo pipefail
cd /sources
rm -rf elfutils-0.194
tar -xf elfutils-0.194.tar.bz2
cd elfutils-0.194

./configure --prefix=/usr        \
            --disable-debuginfod \
            --enable-libdebuginfod=dummy

make -C lib
make -C libelf

make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a

cd /sources
rm -rf elfutils-0.194
echo "### 480-libelf: complete"
