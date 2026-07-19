#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (mpc) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf mpc-1.3.1
tar -xf mpc-1.3.1.tar.gz
cd mpc-1.3.1

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.3.1

make
make html

make install
make install-html

cd /sources
rm -rf mpc-1.3.1
echo "### 220-mpc: complete"
