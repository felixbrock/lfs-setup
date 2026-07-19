#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (sed) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf sed-4.10
tar -xf sed-4.10.tar.xz
cd sed-4.10

./configure --prefix=/usr

make
make html

make install
install -d -m755           /usr/share/doc/sed-4.10
install -m644 doc/sed.html /usr/share/doc/sed-4.10

cd /sources
rm -rf sed-4.10
echo "### 300-sed: complete"
