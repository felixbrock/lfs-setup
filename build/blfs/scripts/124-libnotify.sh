#!/bin/bash
# Generated from BLFS 13.0-systemd (x/libnotify.html) — runs inside chroot as root
# Included book blocks: [0, 2] of 3
# skipped: 1 (optional gi-docgen docs)
set -euo pipefail
cd /sources/blfs
rm -rf libnotify-0.8.8
tar -xf libnotify-0.8.8.tar.xz
cd libnotify-0.8.8

mkdir build
cd    build

# -D tests=false: the test programs need GTK4 (not in tier 1);
# notify-send itself only needs glib + gdk-pixbuf
meson setup --prefix=/usr       \
            --buildtype=release \
            -D gtk_doc=false    \
            -D man=false        \
            -D tests=false      \
            ..
ninja

ninja install
if [ -e /usr/share/doc/libnotify ]; then
  rm -rf /usr/share/doc/libnotify-0.8.8
  mv -v  /usr/share/doc/libnotify{,-0.8.8}
fi

cd /sources/blfs
rm -rf libnotify-0.8.8
echo "### 124-libnotify: complete"
