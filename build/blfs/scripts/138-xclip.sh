#!/bin/bash
# upstream, not in BLFS — autotools, autoreconf -i first (per package list) — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf xclip-0.13
tar -xf xclip-0.13.tar.gz
cd xclip-0.13

autoreconf -i
./configure --prefix=/usr
make

make install

cd /sources/blfs
rm -rf xclip-0.13
echo "### 138-xclip: complete"
