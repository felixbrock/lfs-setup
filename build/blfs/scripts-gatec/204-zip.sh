#!/bin/bash
# Generated from BLFS 13.0-systemd (general/zip.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
set -euo pipefail
cd /sources/blfs
rm -rf zip30
tar -xf zip30.tar.gz
cd zip30

make -f unix/Makefile generic CC="gcc -std=gnu89"

make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install

cd /sources/blfs
rm -rf zip30
echo "### 204-zip: complete"
