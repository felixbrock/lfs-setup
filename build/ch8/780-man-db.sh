#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (man-db) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf man-db-2.13.1
tar -xf man-db-2.13.1.tar.xz
cd man-db-2.13.1

./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.13.1 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap

make

make install

cd /sources
rm -rf man-db-2.13.1
echo "### 780-man-db: complete"
