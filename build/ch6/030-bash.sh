#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (bash)
set -euo pipefail
cd "$LFS/sources"
rm -rf bash-5.3
tar -xf bash-5.3.tar.gz
cd bash-5.3

./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc

make

make DESTDIR=$LFS install

ln -sv bash $LFS/bin/sh

cd "$LFS/sources"
rm -rf bash-5.3
echo "### 030-bash: complete"
