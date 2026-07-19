#!/bin/bash
# BLFS upower 1.91.1 — battery/power D-Bus service; thermald requires
# upower-glib (and the i3blocks battery blocks can use it on metal).
# Runs inside chroot.
set -euo pipefail
cd /sources/gated
rm -rf upower-v1.91.1
tar -xf upower-v1.91.1.tar.bz2
cd upower-v1.91.1

mkdir build
cd build
meson setup .. \
      --prefix=/usr \
      --buildtype=release \
      -D gtk-doc=false \
      -D man=false
ninja
ninja install

systemctl enable upower

cd /sources/gated
rm -rf upower-v1.91.1
echo "### 148-upower: complete"
