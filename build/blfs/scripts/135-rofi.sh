#!/bin/bash
# upstream, not in BLFS — meson; package-list overrides -D wayland=disabled -D imdkit=false — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf rofi-2.0.0
tar -xf rofi-2.0.0.tar.xz
cd rofi-2.0.0

mkdir build
cd    build

meson setup --prefix=/usr       \
            --buildtype=release \
            -D wayland=disabled \
            -D imdkit=false     \
            ..
ninja

ninja install

cd /sources/blfs
rm -rf rofi-2.0.0
echo "### 135-rofi: complete"
