#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (grep)
set -euo pipefail
cd "$LFS/sources"
rm -rf grep-3.12
tar -xf grep-3.12.tar.xz
cd grep-3.12

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)

make

make DESTDIR=$LFS install

cd "$LFS/sources"
rm -rf grep-3.12
echo "### 090-grep: complete"
