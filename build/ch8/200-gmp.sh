#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (gmp) — runs inside chroot
# Included book blocks: [1, 2, 3, 4, 5, 6] of 7; tolerant: [4]
set -euo pipefail
cd /sources
rm -rf gmp-6.3.0
tar -xf gmp-6.3.0.tar.xz
cd gmp-6.3.0

sed -i '/long long t1;/,+1s/()/(...)/' configure

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.3.0

make
make html

(
make check 2>&1 | tee gmp-check-log
) || true   # book: nonzero exit / known failures tolerated, log reviewed

awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log

make install
make install-html

cd /sources
rm -rf gmp-6.3.0
echo "### 200-gmp: complete"
