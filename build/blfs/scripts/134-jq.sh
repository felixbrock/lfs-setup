#!/bin/bash
# upstream, not in BLFS — autotools, --with-oniguruma=builtin (per package list) — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf jq-1.8.2
tar -xf jq-1.8.2.tar.gz
cd jq-1.8.2

./configure --prefix=/usr --with-oniguruma=builtin
make

make install

cd /sources/blfs
rm -rf jq-1.8.2
echo "### 134-jq: complete"
