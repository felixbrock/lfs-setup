#!/bin/bash
# libpsl (BLFS) — required by curl 8.x; missed in the initial dep walk.
set -euo pipefail
cd /sources/blfs
rm -rf libpsl-0.21.5
tar -xf libpsl-0.21.5.tar.gz
cd libpsl-0.21.5

mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release
ninja

ninja install

cd /sources/blfs
rm -rf libpsl-0.21.5
echo "### 211b-libpsl: complete"
