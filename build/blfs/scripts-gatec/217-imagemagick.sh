#!/bin/bash
# Generated from BLFS 13.0-systemd (general/imagemagick.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
# standard book build; delegates limited to what is installed (png/jpeg/freetype/fontconfig/libxml2)
set -euo pipefail
cd /sources/blfs
rm -rf ImageMagick-7.1.2-27
tar -xf ImageMagick-7.1.2-27.tar.gz
cd ImageMagick-7.1.2-27

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-hdri     \
            --with-modules    \
            --with-perl       \
            --disable-static
make

make DOCUMENTATION_PATH=/usr/share/doc/imagemagick-7.1.2 install

cd /sources/blfs
rm -rf ImageMagick-7.1.2-27
echo "### 217-imagemagick: complete"
