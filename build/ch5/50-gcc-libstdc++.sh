#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 5 (gcc-libstdc++)
set -euo pipefail
cd "$LFS/sources"
rm -rf gcc-15.2.0
tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0

mkdir -v build
cd       build

../libstdc++-v3/configure      \
    --host=$LFS_TGT            \
    --build=$(../config.guess) \
    --prefix=/usr              \
    --disable-multilib         \
    --disable-nls              \
    --disable-libstdcxx-pch    \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/15.2.0

make

make DESTDIR=$LFS install

rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la

cd "$LFS/sources"
rm -rf gcc-15.2.0
echo "### 50-gcc-libstdc++: complete"
