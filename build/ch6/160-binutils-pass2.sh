#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (binutils-pass2)
set -euo pipefail
cd "$LFS/sources"
rm -rf binutils-2.46.0
tar -xf binutils-2.46.0.tar.xz
cd binutils-2.46.0

sed '6031s/$add_dir//' -i ltmain.sh

mkdir -v build
cd       build

../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu

make

make DESTDIR=$LFS install

rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

cd "$LFS/sources"
rm -rf binutils-2.46.0
echo "### 160-binutils-pass2: complete"
