#!/bin/bash
# upstream, not in BLFS — autotools (git archive: autoreconf needed); installs libconfig.pc for picom — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf libconfig-1.8.2
tar -xf libconfig-1.8.2.tar.gz
cd libconfig-1.8.2

autoreconf -fi
./configure --prefix=/usr --disable-static
make

make install

cd /sources/blfs
rm -rf libconfig-1.8.2
echo "### 141-libconfig: complete"
