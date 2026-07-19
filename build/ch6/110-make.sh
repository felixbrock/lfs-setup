#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (make)
set -euo pipefail
cd "$LFS/sources"
rm -rf make-4.4.1
tar -xf make-4.4.1.tar.gz
cd make-4.4.1

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

cd "$LFS/sources"
rm -rf make-4.4.1
echo "### 110-make: complete"
