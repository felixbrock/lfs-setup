#!/bin/bash
# Generated from BLFS 13.0-systemd (general/shared-mime-info.html) — runs inside chroot as root
# Included book blocks: [1, 2] of 3
# skipped: 0 (xdgmime, test suite only)
set -euo pipefail
cd /sources/blfs
rm -rf shared-mime-info-2.4
tar -xf shared-mime-info-2.4.tar.gz
cd shared-mime-info-2.4

mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release -D update-mimedb=true ..
ninja

ninja install

cd /sources/blfs
rm -rf shared-mime-info-2.4
echo "### 017-shared-mime-info: complete"
