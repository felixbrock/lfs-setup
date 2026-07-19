#!/bin/bash
# BLFS json-c 0.18 — cryptsetup (LUKS2 metadata) dependency. Runs inside chroot.
set -euo pipefail
cd /sources/gated
rm -rf json-c-0.18
tar -xf json-c-0.18.tar.gz
cd json-c-0.18

# book: cmake-4 compatibility
sed -i 's/VERSION 2.8/VERSION 4.0/' apps/CMakeLists.txt
sed -i 's/VERSION 3.9/VERSION 4.0/' tests/CMakeLists.txt

mkdir build
cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release \
      -D BUILD_STATIC_LIBS=OFF \
      ..
make
make install

cd /sources/gated
rm -rf json-c-0.18
echo "### 030-json-c: complete"
