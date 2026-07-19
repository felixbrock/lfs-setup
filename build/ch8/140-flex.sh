#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (flex) — runs inside chroot
# Included book blocks: [0, 1, 3, 4] of 5; tolerant: []
set -euo pipefail
cd /sources
rm -rf flex-2.6.4
tar -xf flex-2.6.4.tar.gz
cd flex-2.6.4

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/flex-2.6.4

make

make install

ln -sv flex   /usr/bin/lex
ln -sv flex.1 /usr/share/man/man1/lex.1

cd /sources
rm -rf flex-2.6.4
echo "### 140-flex: complete"
