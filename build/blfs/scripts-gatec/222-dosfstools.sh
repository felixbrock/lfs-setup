#!/bin/bash
# Generated from BLFS 13.0-systemd (postlfs/dosfstools.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
set -euo pipefail
cd /sources/blfs
rm -rf dosfstools-4.2
tar -xf dosfstools-4.2.tar.gz
cd dosfstools-4.2

./configure --prefix=/usr            \
            --enable-compat-symlinks \
            --mandir=/usr/share/man  \
            --docdir=/usr/share/doc/dosfstools-4.2
make

make install

cd /sources/blfs
rm -rf dosfstools-4.2
echo "### 222-dosfstools: complete"
