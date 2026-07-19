#!/bin/bash
# iptables (BLFS postlfs/iptables.html) — docker networking requirement.
set -euo pipefail
cd /sources/blfs
rm -rf iptables-1.8.12
tar -xf iptables-1.8.12.tar.xz
cd iptables-1.8.12

./configure --prefix=/usr      \
            --disable-nftables \
            --enable-libipq
make

make install

cd /sources/blfs
rm -rf iptables-1.8.12
echo "### 235-iptables: complete"
