#!/bin/bash
# Generated from BLFS 13.0-systemd (general/nspr.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
set -euo pipefail
cd /sources/blfs
rm -rf nspr-4.38.2
tar -xf nspr-4.38.2.tar.gz
cd nspr-4.38.2

cd nspr

sed -i '/^RELEASE/s|^|#|' pr/src/misc/Makefile.in
sed -i 's|$(LIBRARY) ||'  config/rules.mk

./configure --prefix=/usr   \
            --with-mozilla  \
            --with-pthreads \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit)
make

make install

cd /sources/blfs
rm -rf nspr-4.38.2
echo "### 314-nspr: complete"
