#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (m4)
set -euo pipefail
cd "$LFS/sources"
rm -rf m4-1.4.21
tar -xf m4-1.4.21.tar.xz
cd m4-1.4.21

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

cd "$LFS/sources"
rm -rf m4-1.4.21
echo "### 010-m4: complete"
