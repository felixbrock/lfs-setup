#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (bzip2) — runs inside chroot
# Included book blocks: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] of 10; tolerant: []
set -euo pipefail
cd /sources
rm -rf bzip2-1.0.8
tar -xf bzip2-1.0.8.tar.gz
cd bzip2-1.0.8

patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch

sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile

sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so
make clean

make

make PREFIX=/usr install

cp -av libbz2.so.* /usr/lib
ln -sfv libbz2.so.1.0.8 /usr/lib/libbz2.so

ln -sfv libbz2.so.1.0.8 /usr/lib/libbz2.so.1

cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done

rm -fv /usr/lib/libbz2.a

cd /sources
rm -rf bzip2-1.0.8
echo "### 050-bzip2: complete"
