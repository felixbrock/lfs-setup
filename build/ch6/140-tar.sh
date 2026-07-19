#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (tar)
set -euo pipefail
cd "$LFS/sources"
rm -rf tar-1.35
tar -xf tar-1.35.tar.xz
cd tar-1.35

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

cd "$LFS/sources"
rm -rf tar-1.35
echo "### 140-tar: complete"
