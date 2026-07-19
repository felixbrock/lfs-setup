#!/bin/bash
# not in BLFS — upstream release tarball, autotools (png/jpeg/gif present as image deps) — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf leptonica-1.85.0
tar -xf leptonica-1.85.0.tar.gz
cd leptonica-1.85.0

./configure --prefix=/usr --disable-static
make

make install

cd /sources/blfs
rm -rf leptonica-1.85.0
echo "### 227-leptonica: complete"
