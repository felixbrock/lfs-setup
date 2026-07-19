#!/bin/bash
# upstream, not in BLFS — meson — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf i3-4.25.1
tar -xf i3-4.25.1.tar.xz
cd i3-4.25.1

mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

cd /sources/blfs
rm -rf i3-4.25.1
echo "### 132-i3: complete"
