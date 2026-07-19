#!/bin/bash
# Generated from BLFS 13.0-systemd (general/libjpeg.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
cd /sources/blfs
rm -rf libjpeg-turbo-3.1.3
tar -xf libjpeg-turbo-3.1.3.tar.gz
cd libjpeg-turbo-3.1.3

mkdir build
cd    build

cmake -D CMAKE_INSTALL_PREFIX=/usr        \
      -D CMAKE_BUILD_TYPE=RELEASE         \
      -D ENABLE_STATIC=FALSE              \
      -D CMAKE_INSTALL_DEFAULT_LIBDIR=lib \
      -D CMAKE_SKIP_INSTALL_RPATH=ON      \
      -D CMAKE_INSTALL_DOCDIR=/usr/share/doc/libjpeg-turbo-3.1.3 \
      ..
make

make install

cd /sources/blfs
rm -rf libjpeg-turbo-3.1.3
echo "### 012-libjpeg-turbo: complete"
