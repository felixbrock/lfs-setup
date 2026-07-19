#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (binutils) — runs inside chroot
# Included book blocks: [0, 1, 2, 3, 4, 5, 6] of 7; tolerant: [3, 4]
set -euo pipefail
cd /sources
rm -rf binutils-2.46.0
tar -xf binutils-2.46.0.tar.xz
cd binutils-2.46.0

mkdir -v build
cd       build

../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --enable-new-dtags  \
             --with-system-zlib  \
             --enable-default-hash-style=gnu

make tooldir=/usr

(
make -k check
) || true   # book: nonzero exit / known failures tolerated, log reviewed

(
grep '^FAIL:' $(find -name '*.log')
) || true   # book: nonzero exit / known failures tolerated, log reviewed

make tooldir=/usr install

rm -rfv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a \
        /usr/share/doc/gprofng/

cd /sources
rm -rf binutils-2.46.0
echo "### 190-binutils: complete"
