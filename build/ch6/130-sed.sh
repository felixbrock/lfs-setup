#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (sed)
set -euo pipefail
cd "$LFS/sources"
rm -rf sed-4.9
tar -xf sed-4.9.tar.xz
cd sed-4.9

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)

make

make DESTDIR=$LFS install

cd "$LFS/sources"
rm -rf sed-4.9
echo "### 130-sed: complete"
