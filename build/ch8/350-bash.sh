#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (bash) — runs inside chroot
# Included book blocks: [0, 1, 4] of 6; tolerant: []
set -euo pipefail
cd /sources
rm -rf bash-5.3
tar -xf bash-5.3.tar.gz
cd bash-5.3

./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            --docdir=/usr/share/doc/bash-5.3

make

make install

cd /sources
rm -rf bash-5.3
echo "### 350-bash: complete"
