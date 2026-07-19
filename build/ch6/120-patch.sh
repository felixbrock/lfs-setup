#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (patch)
set -euo pipefail
cd "$LFS/sources"
rm -rf patch-2.8
tar -xf patch-2.8.tar.xz
cd patch-2.8

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

cd "$LFS/sources"
rm -rf patch-2.8
echo "### 120-patch: complete"
