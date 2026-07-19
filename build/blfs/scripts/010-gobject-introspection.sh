#!/bin/bash
# Generated from BLFS 13.0-systemd (general/glib2.html) — runs inside chroot as root
# Included book blocks: [2, 3, 5, 6, 7, 9] of 10
# gobject-introspection build + glib rebuild with -D introspection=enabled (glib re-extracted per plan). skipped: 8 (optional docs). DEVIATION: man-pages disabled (docutils not installed)
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

tar xf ../../gobject-introspection-1.86.0.tar.xz

meson setup gobject-introspection-1.86.0 gi-build \
            --prefix=/usr --buildtype=release
ninja -C gi-build

ninja -C gi-build install

meson configure -D introspection=enabled
ninja

ninja install

cd /sources/blfs
rm -rf glib-2.88.2
echo "### 010-gobject-introspection: complete"
