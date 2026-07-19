#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (gawk) — runs inside chroot
# Included book blocks: [0, 1, 2, 4, 5] of 7; tolerant: []
set -euo pipefail
cd /sources
rm -rf gawk-5.3.2
tar -xf gawk-5.3.2.tar.xz
cd gawk-5.3.2

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr

make

rm -f /usr/bin/gawk-5.3.2
make install

ln -sv gawk.1 /usr/share/man/man1/awk.1

cd /sources
rm -rf gawk-5.3.2
echo "### 610-gawk: complete"
