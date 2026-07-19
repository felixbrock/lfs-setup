#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (grep) — runs inside chroot
# Included book blocks: [0, 1, 2, 4] of 5; tolerant: []
set -euo pipefail
cd /sources
rm -rf grep-3.12
tar -xf grep-3.12.tar.xz
cd grep-3.12

sed -i "s/echo/#echo/" src/egrep.sh

./configure --prefix=/usr

make

make install

cd /sources
rm -rf grep-3.12
echo "### 340-grep: complete"
