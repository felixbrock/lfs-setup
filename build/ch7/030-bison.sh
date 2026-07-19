#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 7 (bison) — runs inside chroot
set -euo pipefail
cd /sources
rm -rf bison-3.8.2
tar -xf bison-3.8.2.tar.xz
cd bison-3.8.2

./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2

make

make install

cd /sources
rm -rf bison-3.8.2
echo "### 030-bison: complete"
