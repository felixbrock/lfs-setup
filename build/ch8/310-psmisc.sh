#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (psmisc) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf psmisc-23.7
tar -xf psmisc-23.7.tar.xz
cd psmisc-23.7

./configure --prefix=/usr

make

make install

cd /sources
rm -rf psmisc-23.7
echo "### 310-psmisc: complete"
