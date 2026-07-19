#!/bin/bash
# Generated from BLFS 13.0-systemd (x/imlib2.html) — runs inside chroot as root
# Included book blocks: [0, 1, 2] of 3
set -euo pipefail
cd /sources/blfs
rm -rf imlib2-1.12.6
tar -xf imlib2-1.12.6.tar.xz
cd imlib2-1.12.6

./configure --prefix=/usr --disable-static
make

make install

# optional docs block dropped: doc/html only exists with doxygen installed

cd /sources/blfs
rm -rf imlib2-1.12.6
echo "### 125-imlib2: complete"
