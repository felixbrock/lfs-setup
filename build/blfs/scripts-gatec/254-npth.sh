#!/bin/bash
# Generated from BLFS 13.0-systemd (general/npth.html) — runs as root
# inside the chroot or on the live LFS system (gnupg batch, 2026-07-17).
# Included book blocks: [0, 1] of 2; '&&' chains split
set -euo pipefail
cd /sources/blfs
rm -rf npth-1.8
tar -xf npth-1.8.tar.bz2
cd npth-1.8

./configure --prefix=/usr
make

make install

cd /sources/blfs
rm -rf npth-1.8
echo "### 254-npth: complete"
