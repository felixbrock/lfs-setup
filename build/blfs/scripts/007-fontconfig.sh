#!/bin/bash
# Generated from BLFS 13.0-systemd (general/fontconfig.html) — runs inside chroot as root
# Included book blocks: [0, 1, 2] of 3
set -euo pipefail
cd /sources/blfs
rm -rf fontconfig-2.17.1
tar -xf fontconfig-2.17.1.tar.xz
cd fontconfig-2.17.1

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-docs       \
            --docdir=/usr/share/doc/fontconfig-2.17.1
make

make install

install -v -dm755 \
        /usr/share/{man/man{1,3,5},doc/fontconfig-2.17.1}
install -v -m644 fc-*/*.1         /usr/share/man/man1
install -v -m644 doc/*.3          /usr/share/man/man3
install -v -m644 doc/fonts-conf.5 /usr/share/man/man5
install -v -m644 doc/*.{pdf,sgml,txt,html} \
                                  /usr/share/doc/fontconfig-2.17.1

cd /sources/blfs
rm -rf fontconfig-2.17.1
echo "### 007-fontconfig: complete"
