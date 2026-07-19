#!/bin/bash
# protobuf (BLFS general/protobuf.html) — runs inside chroot.
set -euo pipefail
cd /sources/blfs
rm -rf protobuf-33.5
tar -xf protobuf-33.5.tar.gz
cd protobuf-33.5

mkdir build
cd    build

# protobuf_ABSL_PROVIDER=package: use the system abseil-cpp (246b), never
# FetchContent-clone at build time
cmake -D CMAKE_INSTALL_PREFIX=/usr      \
      -D CMAKE_BUILD_TYPE=Release       \
      -D CMAKE_SKIP_INSTALL_RPATH=ON    \
      -D protobuf_BUILD_TESTS=OFF       \
      -D protobuf_BUILD_SHARED_LIBS=ON  \
      -D protobuf_ABSL_PROVIDER=package \
      -G Ninja ..
ninja

ninja install

cd /sources/blfs
rm -rf protobuf-33.5
echo "### 247-protobuf: complete"
