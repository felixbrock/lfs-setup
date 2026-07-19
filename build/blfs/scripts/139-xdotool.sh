#!/bin/bash
# Generated from BLFS 13.0-systemd (general/xdotool.html) — runs inside chroot as root
# Included book blocks: [0, 1, 3] of 4
# skipped: 2 (test build)
set -euo pipefail
cd /sources/blfs
rm -rf xdotool-4.20251130.1
tar -xf xdotool-4.20251130.1.tar.gz
cd xdotool-4.20251130.1

sed -i 's#/local##' libxdo.pc

make WITHOUT_RPATH_FIX=1

make PREFIX=/usr INSTALLMAN=/usr/share/man install

cd /sources/blfs
rm -rf xdotool-4.20251130.1
echo "### 139-xdotool: complete"
