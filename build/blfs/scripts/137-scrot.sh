#!/bin/bash
# upstream, not in BLFS — autotools (release tarball ships configure) — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf scrot-2.0.0
tar -xf scrot-2.0.0.tar.gz
cd scrot-2.0.0

./configure --prefix=/usr
make

make install

cd /sources/blfs
rm -rf scrot-2.0.0
echo "### 137-scrot: complete"
