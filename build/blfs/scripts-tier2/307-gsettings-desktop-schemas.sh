#!/bin/bash
# Generated from BLFS 13.0-systemd (gnome/gsettings-desktop-schemas.html) — runs inside chroot as root
# Included book blocks: [0, 1, 2] of 3; '&&' chains split into plain statements
set -euo pipefail
cd /sources/blfs
rm -rf gsettings-desktop-schemas-49.1
tar -xf gsettings-desktop-schemas-49.1.tar.xz
cd gsettings-desktop-schemas-49.1

sed -i -r 's:"(/system):"/org/gnome\1:g' schemas/*.in

mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

glib-compile-schemas /usr/share/glib-2.0/schemas

cd /sources/blfs
rm -rf gsettings-desktop-schemas-49.1
echo "### 307-gsettings-desktop-schemas: complete"
