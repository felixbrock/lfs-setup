#!/bin/bash
# Generated from BLFS 13.0-systemd (x/gtk3.html) — runs inside chroot as root
# Included book blocks: [0, 1, 2, 3] of 6; '&&' chains split into plain statements
# -D wayland_backend=false added per plan. skipped: 4+5 (per-user settings.ini/gtk.css). DEVIATION: -D man=false (xsltproc/docbook not installed)
set -euo pipefail
cd /sources/blfs
rm -rf gtk-3.24.51
tar -xf gtk-3.24.51.tar.xz
cd gtk-3.24.51

mkdir build
cd    build

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D man=false         \
      -D broadway_backend=true \
      -D wayland_backend=false
ninja

ninja install

gtk-query-immodules-3.0 --update-cache

glib-compile-schemas /usr/share/glib-2.0/schemas

cd /sources/blfs
rm -rf gtk-3.24.51
echo "### 310-gtk3: complete"
