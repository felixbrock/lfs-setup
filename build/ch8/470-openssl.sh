#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (openssl) — runs inside chroot
# Included book blocks: [0, 1, 3, 4] of 6; tolerant: []
set -euo pipefail
cd /sources
rm -rf openssl-3.6.3
tar -xf openssl-3.6.3.tar.gz
cd openssl-3.6.3

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic

make

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install

mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.6.3

cd /sources
rm -rf openssl-3.6.3
echo "### 470-openssl: complete"
