#!/bin/bash
# Generated from BLFS 13.0-systemd (x/pango.html) — runs inside chroot as root
# Included book blocks: [0, 3] of 4
# skipped: 1 (man pages, needs docutils), 2 (optional docs)
set -euo pipefail
cd /sources/blfs
rm -rf pango-1.57.0
tar -xf pango-1.57.0.tar.xz
cd pango-1.57.0

mkdir build
cd    build

meson setup --prefix=/usr            \
            --buildtype=release      \
            --wrap-mode=nofallback   \
            -D introspection=enabled \
            ..
ninja

ninja install

cd /sources/blfs
rm -rf pango-1.57.0
echo "### 122-pango: complete"
