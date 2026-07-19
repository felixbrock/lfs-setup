#!/bin/bash
# not in BLFS — upstream i3 project release, meson (PAM, cairo, xcb, libxkbcommon all present) — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf i3lock-2.15
tar -xf i3lock-2.15.tar.xz
cd i3lock-2.15

mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

cd /sources/blfs
rm -rf i3lock-2.15
echo "### 218-i3lock: complete"
