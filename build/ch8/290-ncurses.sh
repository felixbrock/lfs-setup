#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (ncurses) — runs inside chroot
# Included book blocks: [0, 1, 2, 3, 4] of 7; tolerant: []
set -euo pipefail
cd /sources
rm -rf ncurses-6.6
tar -xf ncurses-6.6.tar.gz
cd ncurses-6.6

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --with-cxx-shared       \
            --enable-pc-files       \
            --with-pkg-config-libdir=/usr/lib/pkgconfig

make

make DESTDIR=$PWD/dest install
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i dest/usr/include/curses.h
cp --remove-destination -av dest/* /

for lib in ncurses form panel menu ; do
    ln -sfv lib${lib}w.so /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc    /usr/lib/pkgconfig/${lib}.pc
done

ln -sfv libncursesw.so /usr/lib/libcurses.so

cd /sources
rm -rf ncurses-6.6
echo "### 290-ncurses: complete"
