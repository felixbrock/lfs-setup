#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (diffutils)
set -euo pipefail
cd "$LFS/sources"
rm -rf diffutils-3.12
tar -xf diffutils-3.12.tar.xz
cd diffutils-3.12

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            gl_cv_func_strcasecmp_works=y \
            --build=$(./build-aux/config.guess)

make

make DESTDIR=$LFS install

cd "$LFS/sources"
rm -rf diffutils-3.12
echo "### 050-diffutils: complete"
