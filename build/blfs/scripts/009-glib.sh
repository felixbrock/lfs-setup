#!/bin/bash
# Generated from BLFS 13.0-systemd (general/glib2.html) — runs inside chroot as root
# Included book blocks: [2, 3, 4] of 10
# plain glib; introspection rebuild happens in 010. skipped: 0 (optional patch), 1 (upgrade-only), 5-9 (g-i/docs). DEVIATION: man-pages disabled (docutils not installed)
set -euo pipefail
cd /sources/blfs
rm -rf glib-2.88.2
tar -xf glib-2.88.2.tar.xz
cd glib-2.88.2


mkdir build
cd    build

meson setup ..                  \
      --prefix=/usr             \
      --buildtype=release       \
      -D introspection=disabled \
      -D glib_debug=disabled    \
      -D man-pages=disabled      \
      -D sysprof=disabled
ninja

ninja install

cd /sources/blfs
rm -rf glib-2.88.2
echo "### 009-glib: complete"
