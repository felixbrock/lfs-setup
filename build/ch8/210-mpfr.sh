#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (mpfr) — runs inside chroot
# Included book blocks: [0, 1, 2, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf mpfr-4.2.2
tar -xf mpfr-4.2.2.tar.xz
cd mpfr-4.2.2

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.2.2

make
make html

make check

make install
make install-html

cd /sources
rm -rf mpfr-4.2.2
echo "### 210-mpfr: complete"
