#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (readline) — runs inside chroot
# Included book blocks: [0, 1, 2, 3, 4, 5] of 7; tolerant: []
set -euo pipefail
cd /sources
rm -rf readline-8.3
tar -xf readline-8.3.tar.gz
cd readline-8.3

sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf

sed -e '270a\
     else\
       chars_avail = 1;'      \
    -e '288i\   result = -1;' \
    -i.orig input.c

./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.3

make SHLIB_LIBS="-lncursesw"

make install

cd /sources
rm -rf readline-8.3
echo "### 100-readline: complete"
