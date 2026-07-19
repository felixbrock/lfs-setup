#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (gdbm) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf gdbm-1.26
tar -xf gdbm-1.26.tar.gz
cd gdbm-1.26

./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat

make

make install

cd /sources
rm -rf gdbm-1.26
echo "### 370-gdbm: complete"
