#!/bin/bash
# BLFS libndp 1.9 — NetworkManager dependency. Runs inside chroot.
set -euo pipefail
cd /sources/gated
rm -rf libndp-1.9
tar -xf libndp-1.9.tar.gz
cd libndp-1.9

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --disable-static
make
make install

cd /sources/gated
rm -rf libndp-1.9
echo "### 100-libndp: complete"
