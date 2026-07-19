#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (attr) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf attr-2.6.0
tar -xf attr-2.6.0.tar.gz
cd attr-2.6.0

./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.6.0

make

make install

cd /sources
rm -rf attr-2.6.0
echo "### 230-attr: complete"
