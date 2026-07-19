#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 5 (binutils-pass1)
set -euo pipefail
cd "$LFS/sources"
rm -rf binutils-2.46.0
tar -xf binutils-2.46.0.tar.xz
cd binutils-2.46.0

mkdir -v build
cd       build

../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu

make

make install

cd "$LFS/sources"
rm -rf binutils-2.46.0
echo "### 10-binutils-pass1: complete"
