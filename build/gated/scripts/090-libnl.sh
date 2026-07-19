#!/bin/bash
# BLFS libnl 3.12.0 — wpa_supplicant dependency. Runs inside chroot.
set -euo pipefail
cd /sources/gated
rm -rf libnl-3.12.0
tar -xf libnl-3.12.0.tar.gz
cd libnl-3.12.0

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-static
make
make install

cd /sources/gated
rm -rf libnl-3.12.0
echo "### 090-libnl: complete"
