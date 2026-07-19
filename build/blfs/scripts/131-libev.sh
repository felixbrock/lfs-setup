#!/bin/bash
# upstream, not in BLFS — autotools — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf libev-4.33
tar -xf libev-4.33.tar.gz
cd libev-4.33

./configure --prefix=/usr --disable-static
make

make install

cd /sources/blfs
rm -rf libev-4.33
echo "### 131-libev: complete"
