#!/bin/bash
# Generated from BLFS 13.0-systemd (general/freetype2.html) — runs inside chroot as root
# Included book blocks: [1, 2] of 4
# skipped: 0+3 (optional docs tarball); --with-harfbuzz=dynamic is in the book block (matches list note)
set -euo pipefail
cd /sources/blfs
rm -rf freetype-2.14.3
tar -xf freetype-2.14.3.tar.xz
cd freetype-2.14.3

sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg

sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h

./configure --prefix=/usr            \
            --disable-static         \
            --enable-freetype-config \
            --with-harfbuzz=dynamic
make

make install

cd /sources/blfs
rm -rf freetype-2.14.3
echo "### 006-freetype: complete"
