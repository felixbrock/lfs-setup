#!/bin/bash
# Generated from BLFS 13.0-systemd (general/hwdata.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
set -euo pipefail
cd /sources/blfs
rm -rf hwdata-0.404
tar -xf hwdata-0.404.tar.gz
cd hwdata-0.404

./configure --prefix=/usr --disable-blacklist

make install

cd /sources/blfs
rm -rf hwdata-0.404
echo "### 224-hwdata: complete"
