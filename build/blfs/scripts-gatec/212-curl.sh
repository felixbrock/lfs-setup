#!/bin/bash
# Generated from BLFS 13.0-systemd (basicnet/curl.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
set -euo pipefail
cd /sources/blfs
rm -rf curl-8.21.0
tar -xf curl-8.21.0.tar.xz
cd curl-8.21.0

./configure --prefix=/usr    \
            --disable-static \
            --with-openssl   \
            --with-ca-path=/etc/ssl/certs
make

make install

rm -rf docs/examples/.deps

find docs \( -name Makefile\* -o  \
             -name \*.1       -o  \
             -name \*.3       -o  \
             -name CMakeLists.txt \) -delete

cp -v -R docs -T /usr/share/doc/curl-8.21.0

cd /sources/blfs
rm -rf curl-8.21.0
echo "### 212-curl: complete"
