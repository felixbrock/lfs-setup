#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (dbus) — runs inside chroot
# Included book blocks: [0, 1, 3, 4] of 5; tolerant: []
set -euo pipefail
cd /sources
rm -rf dbus-1.16.2
tar -xf dbus-1.16.2.tar.xz
cd dbus-1.16.2

mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release --wrap-mode=nofallback ..

ninja

ninja install

ln -sfv /etc/machine-id /var/lib/dbus

cd /sources
rm -rf dbus-1.16.2
echo "### 770-dbus: complete"
