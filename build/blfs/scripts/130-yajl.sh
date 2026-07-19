#!/bin/bash
# upstream, not in BLFS — cmake — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf yajl-2.1.0
tar -xf yajl-2.1.0.tar.gz
cd yajl-2.1.0

mkdir build
cd    build

# yajl 2.1.0 (2015) reads the LOCATION target property in its tool/test
# subdirs, removed in CMake 4. Only the library is needed (for i3) — drop
# the tools, tests, and docs from the build.
sed -i -E '/ADD_SUBDIRECTORY\s*\(\s*(reformatter|verify|perf|test)\s*\)/Id' ../CMakeLists.txt

cmake -D CMAKE_INSTALL_PREFIX=/usr           \
      -D CMAKE_BUILD_TYPE=Release            \
      -D CMAKE_POLICY_VERSION_MINIMUM=3.5    \
      ..
make

make install

cd /sources/blfs
rm -rf yajl-2.1.0
echo "### 130-yajl: complete"
