#!/bin/bash
# Generated from BLFS 13.0-systemd (general/llvm.html) — runs inside chroot as root
# Included book blocks: [0, 3, 4, 5, 8] of 10; '&&' chains split into plain statements
# llvm-cmake + llvm-third-party sibling tarballs unpacked per book (block 0). skipped: 2 (compiler-rt — not needed), 6+7 (tests), 9 (clang config files). Block 1 (clang) ADDED 2026-07-16: mesa iris needs intel-clc at build time -> clang + libclc (see 3025-libclc). DEVIATION per plan: LLVM_TARGETS_TO_BUILD=X86 instead of "host;AMDGPU" (book allows choosing targets; AMDGPU codegen not needed, radeonsi uses LLVM X86 JIT)
set -euo pipefail
cd /sources/blfs
rm -rf llvm-21.1.8.src
tar -xf llvm-21.1.8.src.tar.xz
cd llvm-21.1.8.src

tar -xf ../llvm-cmake-21.1.8.src.tar.xz
tar -xf ../llvm-third-party-21.1.8.src.tar.xz

tar -xf ../clang-21.1.8.src.tar.xz -C tools
mv tools/clang-21.1.8.src tools/clang
sed '/LLVM_COMMON_CMAKE_UTILS/s@../cmake@cmake-21.1.8.src@'          \
    -i CMakeLists.txt
sed '/LLVM_THIRD_PARTY_DIR/s@../third-party@third-party-21.1.8.src@' \
    -i cmake/modules/HandleLLVMOptions.cmake

grep -rl '#!.*python' | xargs sed -i '1s/python$/python3/'

sed 's/utility/tool/' -i utils/FileCheck/CMakeLists.txt

mkdir -v build
cd       build

CC=gcc CXX=g++                               \
cmake -D CMAKE_INSTALL_PREFIX=/usr           \
      -D CMAKE_SKIP_INSTALL_RPATH=ON         \
      -D LLVM_ENABLE_FFI=ON                  \
      -D CMAKE_BUILD_TYPE=Release            \
      -D LLVM_BUILD_LLVM_DYLIB=ON            \
      -D LLVM_LINK_LLVM_DYLIB=ON             \
      -D LLVM_ENABLE_RTTI=ON                 \
      -D LLVM_TARGETS_TO_BUILD=X86          \
      -D LLVM_BINUTILS_INCDIR=/usr/include   \
      -D LLVM_INCLUDE_BENCHMARKS=OFF         \
      -D CLANG_DEFAULT_PIE_ON_LINUX=ON       \
      -D CLANG_CONFIG_FILE_SYSTEM_DIR=/etc/clang \
      -W no-dev -G Ninja ..
# -j8: this machine has 16 GB and NO swap — clang's Sema TUs OOM at the
# default -j20 (cc1plus killed, seen 2026-07-19 first native run; the
# chroot-era build of the same tree survived only because Arch had swap)
ninja -j8

ninja install

cd /sources/blfs
rm -rf llvm-21.1.8.src

# libclc (same llvm-project release) — mesa iris' intel-clc needs it at
# build time; requires the clang just installed above. Kept in this
# script: a separate 302x/3025 file sorts unpredictably vs 302/303
# under locale collation (bit us 2026-07-16).
rm -rf libclc-21.1.8.src
tar -xf libclc-21.1.8.src.tar.xz
cd libclc-21.1.8.src

mkdir build
cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release \
      -G Ninja ..
ninja
ninja install

command -v clang > /dev/null
test -e /usr/share/pkgconfig/libclc.pc

cd /sources/blfs
rm -rf libclc-21.1.8.src
echo "### 302-llvm: complete (llvm + clang + libclc)"
