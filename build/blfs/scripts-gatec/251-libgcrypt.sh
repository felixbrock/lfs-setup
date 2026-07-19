#!/bin/bash
# Generated from BLFS 13.0-systemd (general/libgcrypt.html) — runs as root
# inside the chroot or on the live LFS system (gnupg batch, 2026-07-17).
# Included book blocks: [0, 1] of 2 minus the makeinfo/html doc build and
# the doc-install lines that depend on it; '&&' chains split
set -euo pipefail
cd /sources/blfs
rm -rf libgcrypt-1.12.0
tar -xf libgcrypt-1.12.0.tar.bz2
cd libgcrypt-1.12.0

./configure --prefix=/usr
make

make install
install -v -dm755 /usr/share/doc/libgcrypt-1.12.0
install -v -m644 README doc/README.apichanges /usr/share/doc/libgcrypt-1.12.0

cd /sources/blfs
rm -rf libgcrypt-1.12.0
echo "### 251-libgcrypt: complete"
