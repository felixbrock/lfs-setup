#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (pkgconf) — runs inside chroot
# Included book blocks: [0, 1, 2, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf pkgconf-2.5.1
tar -xf pkgconf-2.5.1.tar.xz
cd pkgconf-2.5.1

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/pkgconf-2.5.1

make

make install

ln -sv pkgconf   /usr/bin/pkg-config
ln -sv pkgconf.1 /usr/share/man/man1/pkg-config.1

cd /sources
rm -rf pkgconf-2.5.1
echo "### 180-pkgconf: complete"
