#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (groff) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf groff-1.23.0
tar -xf groff-1.23.0.tar.gz
cd groff-1.23.0

PAGE=A4 ./configure --prefix=/usr

make

make install

cd /sources
rm -rf groff-1.23.0
echo "### 630-groff: complete"
