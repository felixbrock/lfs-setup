#!/bin/bash
# Generated from BLFS 13.0-systemd (postlfs/nano.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
set -euo pipefail
cd /sources/blfs
rm -rf nano-9.0
tar -xf nano-9.0.tar.xz
cd nano-9.0

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-utf8     \
            --docdir=/usr/share/doc/nano-9.0
make

make install
install -v -m644 doc/{nano.html,sample.nanorc} /usr/share/doc/nano-9.0

cd /sources/blfs
rm -rf nano-9.0
echo "### 201-nano: complete"
