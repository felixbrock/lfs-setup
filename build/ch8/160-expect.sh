#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (expect) — runs inside chroot
# Included book blocks: [0, 1, 2, 3, 5] of 6; tolerant: []
set -euo pipefail
cd /sources
rm -rf expect5.45.4
tar -xf expect5.45.4.tar.gz
cd expect5.45.4

python3 -c 'from pty import spawn; spawn(["echo", "ok"])'

patch -Np1 -i ../expect-5.45.4-gcc15-1.patch

./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --disable-rpath         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include

make

make install
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib

cd /sources
rm -rf expect5.45.4
echo "### 160-expect: complete"
