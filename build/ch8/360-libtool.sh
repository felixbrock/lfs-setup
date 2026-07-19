#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (libtool) — runs inside chroot
# Included book blocks: [0, 1, 3, 4] of 5; tolerant: []
set -euo pipefail
cd /sources
rm -rf libtool-2.5.4
tar -xf libtool-2.5.4.tar.xz
cd libtool-2.5.4

./configure --prefix=/usr

make

make install

rm -fv /usr/lib/libltdl.a

cd /sources
rm -rf libtool-2.5.4
echo "### 360-libtool: complete"
