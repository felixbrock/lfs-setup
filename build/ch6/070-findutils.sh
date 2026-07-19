#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (findutils)
set -euo pipefail
cd "$LFS/sources"
rm -rf findutils-4.10.0
tar -xf findutils-4.10.0.tar.xz
cd findutils-4.10.0

./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

cd "$LFS/sources"
rm -rf findutils-4.10.0
echo "### 070-findutils: complete"
