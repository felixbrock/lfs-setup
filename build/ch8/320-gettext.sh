#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (gettext) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf gettext-1.0
tar -xf gettext-1.0.tar.xz
cd gettext-1.0

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-1.0

make

make install
chmod -v 0755 /usr/lib/preloadable_libintl.so

cd /sources
rm -rf gettext-1.0
echo "### 320-gettext: complete"
