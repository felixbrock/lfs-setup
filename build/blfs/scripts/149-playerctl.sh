#!/bin/bash
# upstream, not in BLFS — meson, -D gtk-doc=false (per package list) — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf playerctl-2.4.1
tar -xf playerctl-2.4.1.tar.gz
cd playerctl-2.4.1

mkdir build
cd    build

meson setup --prefix=/usr       \
            --buildtype=release \
            -D gtk-doc=false    \
            ..
ninja

ninja install

cd /sources/blfs
rm -rf playerctl-2.4.1
echo "### 149-playerctl: complete"
