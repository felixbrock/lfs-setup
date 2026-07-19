#!/bin/bash
# Generated from BLFS 13.0-systemd (general/libgpg-error.html) — runs as root
# inside the chroot or on the live LFS system (gnupg batch, 2026-07-17).
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
set -euo pipefail
cd /sources/blfs
rm -rf libgpg-error-1.59
tar -xf libgpg-error-1.59.tar.bz2
cd libgpg-error-1.59

./configure --prefix=/usr --sysconfdir=/etc
make

make install
install -v -m644 -D README /usr/share/doc/libgpg-error-1.59/README

cd /sources/blfs
rm -rf libgpg-error-1.59
echo "### 250-libgpg-error: complete"
