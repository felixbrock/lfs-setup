#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (gawk)
set -euo pipefail
cd "$LFS/sources"
rm -rf gawk-5.3.2
tar -xf gawk-5.3.2.tar.xz
cd gawk-5.3.2

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

cd "$LFS/sources"
rm -rf gawk-5.3.2
echo "### 080-gawk: complete"
