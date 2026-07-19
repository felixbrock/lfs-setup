#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 7 (Python) — runs inside chroot
set -euo pipefail
cd /sources
rm -rf Python-3.14.3
tar -xf Python-3.14.3.tar.xz
cd Python-3.14.3

./configure --prefix=/usr       \
            --enable-shared     \
            --without-ensurepip \
            --without-static-libpython

make

make install

cd /sources
rm -rf Python-3.14.3
echo "### 045-python: complete"
