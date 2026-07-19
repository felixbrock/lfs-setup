#!/bin/bash
# not in BLFS 13.0 — upstream GitHub archive, make; static lib removed (old-BLFS style) — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf xxHash-0.8.3
tar -xf xxhash-0.8.3.tar.gz
cd xxHash-0.8.3

make PREFIX=/usr

make PREFIX=/usr install
rm -fv /usr/lib/libxxhash.a

cd /sources/blfs
rm -rf xxHash-0.8.3
echo "### 215-xxhash: complete"
