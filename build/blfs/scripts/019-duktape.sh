#!/bin/bash
# Generated from BLFS 13.0-systemd (general/duktape.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
cd /sources/blfs
rm -rf duktape-2.7.0
tar -xf duktape-2.7.0.tar.xz
cd duktape-2.7.0

sed -i 's/-Os/-O2/' Makefile.sharedlibrary
make -f Makefile.sharedlibrary INSTALL_PREFIX=/usr

make -f Makefile.sharedlibrary INSTALL_PREFIX=/usr install

cd /sources/blfs
rm -rf duktape-2.7.0
echo "### 019-duktape: complete"
