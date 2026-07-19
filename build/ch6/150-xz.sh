#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (xz)
set -euo pipefail
cd "$LFS/sources"
rm -rf xz-5.8.2
tar -xf xz-5.8.2.tar.xz
cd xz-5.8.2

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.8.2

make

make DESTDIR=$LFS install

rm -v $LFS/usr/lib/liblzma.la

cd "$LFS/sources"
rm -rf xz-5.8.2
echo "### 150-xz: complete"
