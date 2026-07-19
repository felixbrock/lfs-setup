#!/bin/bash
# Generated from BLFS 13.0-systemd (basicnet/libevent.html) — runs inside chroot as root
# Included book blocks: [0, 1, 3] of 5; '&&' chains split into plain statements
# skipped: 2+4 (doxygen docs)
set -euo pipefail
cd /sources/blfs
rm -rf libevent-2.1.12-stable
tar -xf libevent-2.1.12-stable.tar.gz
cd libevent-2.1.12-stable

sed -i 's/python/&3/' event_rpcgen.py

./configure --prefix=/usr --disable-static
make

make install

cd /sources/blfs
rm -rf libevent-2.1.12-stable
echo "### 207-libevent: complete"
