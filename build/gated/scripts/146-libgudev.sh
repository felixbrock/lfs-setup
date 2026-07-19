#!/bin/bash
# BLFS libgudev 238 — upower dependency (thermald chain). Runs inside chroot.
set -euo pipefail
cd /sources/gated
rm -rf libgudev-238
tar -xf libgudev-238.tar.xz
cd libgudev-238

mkdir build
cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
ninja install

cd /sources/gated
rm -rf libgudev-238
echo "### 146-libgudev: complete"
