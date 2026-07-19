#!/bin/bash
# Generated from BLFS 13.0-systemd (general/which.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 3; '&&' chains split into plain statements
# skipped: 2 (alternative bash-script which, not needed when installing the package)
set -euo pipefail
cd /sources/blfs
rm -rf which-2.23
tar -xf which-2.23.tar.gz
cd which-2.23

./configure --prefix=/usr
make

make install

cd /sources/blfs
rm -rf which-2.23
echo "### 200-which: complete"
