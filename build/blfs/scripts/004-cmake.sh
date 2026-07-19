#!/bin/bash
# Generated from BLFS 13.0-systemd (general/cmake.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
# DEVIATION: added --no-system-{curl,libarchive,libuv,nghttp2}; those libs are not in LFS/tier-1
set -euo pipefail
cd /sources/blfs
rm -rf cmake-4.2.3
tar -xf cmake-4.2.3.tar.gz
cd cmake-4.2.3

sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake

./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-cppdap   \
            --no-system-librhash \
            --no-system-curl     \
            --no-system-libarchive \
            --no-system-libuv    \
            --no-system-nghttp2  \
            --docdir=/share/doc/cmake-4.2.3
make

make install

cd /sources/blfs
rm -rf cmake-4.2.3
echo "### 004-cmake: complete"
