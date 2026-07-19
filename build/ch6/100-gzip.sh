#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (gzip)
set -euo pipefail
cd "$LFS/sources"
rm -rf gzip-1.14
tar -xf gzip-1.14.tar.xz
cd gzip-1.14

./configure --prefix=/usr --host=$LFS_TGT

make

make DESTDIR=$LFS install

cd "$LFS/sources"
rm -rf gzip-1.14
echo "### 100-gzip: complete"
