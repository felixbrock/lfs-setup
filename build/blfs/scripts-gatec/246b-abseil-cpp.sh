#!/bin/bash
# abseil-cpp (BLFS general/abseil-cpp.html) — required dependency of
# protobuf 33.5 (missed in the initial straggler dep walk; without it
# protobuf FetchContent-clones abseil at build time, which fails/violates
# the no-network-during-build rule).
set -euo pipefail
cd /sources/blfs
rm -rf abseil-cpp-20260107.1
tar -xf abseil-cpp-20260107.1.tar.gz
cd abseil-cpp-20260107.1

mkdir build
cd    build

cmake -D CMAKE_INSTALL_PREFIX=/usr   \
      -D CMAKE_BUILD_TYPE=Release    \
      -D CMAKE_SKIP_INSTALL_RPATH=ON \
      -D ABSL_PROPAGATE_CXX_STD=ON   \
      -D BUILD_SHARED_LIBS=ON        \
      -G Ninja ..
ninja

ninja install

cd /sources/blfs
rm -rf abseil-cpp-20260107.1
echo "### 246b-abseil-cpp: complete"
