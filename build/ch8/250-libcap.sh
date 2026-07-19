#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (libcap) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf libcap-2.78
tar -xf libcap-2.78.tar.xz
cd libcap-2.78

sed -i '/install -m.*STA/d' libcap/Makefile

make prefix=/usr lib=lib

make prefix=/usr lib=lib install

cd /sources
rm -rf libcap-2.78
echo "### 250-libcap: complete"
