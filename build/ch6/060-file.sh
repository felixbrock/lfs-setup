#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (file)
set -euo pipefail
cd "$LFS/sources"
rm -rf file-5.46
tar -xf file-5.46.tar.gz
cd file-5.46

mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd

./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)

make FILE_COMPILE=$(pwd)/build/src/file

make DESTDIR=$LFS install

rm -v $LFS/usr/lib/libmagic.la

cd "$LFS/sources"
rm -rf file-5.46
echo "### 060-file: complete"
