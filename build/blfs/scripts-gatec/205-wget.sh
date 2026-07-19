#!/bin/bash
# Generated from BLFS 13.0-systemd (basicnet/wget.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
# --with-ssl=openssl is in the book block
set -euo pipefail
cd /sources/blfs
rm -rf wget-1.25.0
tar -xf wget-1.25.0.tar.gz
cd wget-1.25.0

./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl
make

make install

cd /sources/blfs
rm -rf wget-1.25.0
echo "### 205-wget: complete"
