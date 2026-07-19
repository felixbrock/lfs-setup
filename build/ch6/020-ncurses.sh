#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 6 (ncurses)
set -euo pipefail
cd "$LFS/sources"
rm -rf ncurses-6.6
tar -xf ncurses-6.6.tar.gz
cd ncurses-6.6

mkdir build
pushd build
  ../configure --prefix=$LFS/tools AWK=gawk
  make -C include
  make -C progs tic
  install progs/tic $LFS/tools/bin
popd

./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-normal             \
            --with-cxx-shared            \
            --without-debug              \
            --without-ada                \
            --disable-stripping          \
            AWK=gawk

make

make DESTDIR=$LFS install
ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i $LFS/usr/include/curses.h

cd "$LFS/sources"
rm -rf ncurses-6.6
echo "### 020-ncurses: complete"
