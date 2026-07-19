#!/bin/bash
# Generated from BLFS (general/giflib.html) — runs inside chroot as root
# 6.1.3 (sa-13.0-010): fix series integrated upstream, the two 5.2.2 BLFS
# patches are obsolete; make install now supports DOCDIR directly.
set -euo pipefail
cd /sources/blfs
rm -rf giflib-6.1.3
tar -xf giflib-6.1.3.tar.gz
cd giflib-6.1.3

make

make PREFIX=/usr DOCDIR=/usr/share/doc/giflib-6.1.3 install

rm -fv /usr/lib/libgif.a

cd /sources/blfs
rm -rf giflib-6.1.3
echo "### 013-giflib: complete"
