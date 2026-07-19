#!/bin/bash
# Generated from BLFS 13.0-systemd (general/graphite2.html) — runs inside chroot as root
# Included book blocks: [1, 2, 3, 5] of 7
# skipped: 0 (test tweak), 4+6 (optional docs)
set -euo pipefail
cd /sources/blfs
rm -rf graphite2-1.3.15
tar -xf graphite2-1.3.15.tgz
cd graphite2-1.3.15

sed -i '/cmake_policy(SET CMP0012 NEW)/d' CMakeLists.txt
sed -i 's/PythonInterp/Python3/' CMakeLists.txt
find . -name CMakeLists.txt | xargs sed -i 's/VERSION 2.8.0 FATAL_ERROR/VERSION 4.0.0/'

sed -i '/Font.h/i #include <cstdint>' tests/featuremap/featuremaptest.cpp

mkdir build
cd    build

cmake -D CMAKE_INSTALL_PREFIX=/usr ..
make

make install

cd /sources/blfs
rm -rf graphite2-1.3.15
echo "### 008-graphite2: complete"
