#!/bin/bash
# BLFS SPIRV chain — mesa's intel-clc (iris) needs LLVMSPIRVLib.
# SPIRV-Headers + SPIRV-Tools (vulkan-sdk-1.4.341.0) +
# SPIRV-LLVM-Translator 21.1.4 (tracks LLVM 21). Requires 302-llvm
# (clang). Named 302z so it sorts between 302-llvm and 303-mesa under
# BOTH C and UTF-8 collation (a 3025- prefix sorted before 302- in
# UTF-8 and bit us on 2026-07-16). Runs inside chroot.
set -euo pipefail
cd /sources/blfs

rm -rf SPIRV-Headers-vulkan-sdk-1.4.341.0
tar -xf SPIRV-Headers-vulkan-sdk-1.4.341.0.tar.gz
cd SPIRV-Headers-vulkan-sdk-1.4.341.0
mkdir build
cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr -G Ninja ..
ninja
ninja install
cd /sources/blfs
rm -rf SPIRV-Headers-vulkan-sdk-1.4.341.0

rm -rf SPIRV-Tools-vulkan-sdk-1.4.341.0
tar -xf SPIRV-Tools-vulkan-sdk-1.4.341.0.tar.gz
cd SPIRV-Tools-vulkan-sdk-1.4.341.0
mkdir build
cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release \
      -D SPIRV_WERROR=OFF \
      -D BUILD_SHARED_LIBS=ON \
      -D SPIRV_TOOLS_BUILD_STATIC=OFF \
      -D SPIRV-Headers_SOURCE_DIR=/usr \
      -G Ninja ..
ninja
ninja install
cd /sources/blfs
rm -rf SPIRV-Tools-vulkan-sdk-1.4.341.0

rm -rf SPIRV-LLVM-Translator-21.1.4
tar -xf SPIRV-LLVM-Translator-21.1.4.tar.gz
cd SPIRV-LLVM-Translator-21.1.4
mkdir build
cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release \
      -D BUILD_SHARED_LIBS=ON \
      -D CMAKE_SKIP_INSTALL_RPATH=ON \
      -D LLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=/usr \
      -G Ninja ..
ninja
ninja install
cd /sources/blfs
rm -rf SPIRV-LLVM-Translator-21.1.4

test -e /usr/lib/pkgconfig/LLVMSPIRVLib.pc
echo "### 302z-spirv: complete"
