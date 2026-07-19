#!/bin/bash
# Generated from BLFS 13.0-systemd (x/gdk-pixbuf.html) — runs inside chroot as root
# Included book blocks: [0, 2] of 4
# skipped: 1 (optional docs), 3 (DESTDIR-only loader cache). Book block disables built-in loaders and falls back to -D glycin=disabled (no glycin in tier 1)
set -euo pipefail
cd /sources/blfs
rm -rf gdk-pixbuf-2.44.6
tar -xf gdk-pixbuf-2.44.6.tar.xz
cd gdk-pixbuf-2.44.6

mkdir build
cd    build

# DEVIATION from book: the book delegates image loading to glycin (Rust,
# circular build — tier 2 at best). Enable the deprecated-but-working
# built-in loaders so rofi/dunst/libnotify can render images in tier 1.
# Also -D man=false: rst2man (docutils) is not in the chroot.
meson setup ..                \
      --prefix=/usr           \
      --buildtype=release     \
      -D png=enabled          \
      -D gif=enabled          \
      -D jpeg=enabled         \
      -D tiff=disabled        \
      -D thumbnailer=disabled \
      -D man=false            \
      -D glycin=disabled      \
      --wrap-mode=nofallback
ninja

ninja install

cd /sources/blfs
rm -rf gdk-pixbuf-2.44.6
echo "### 018-gdk-pixbuf: complete"
