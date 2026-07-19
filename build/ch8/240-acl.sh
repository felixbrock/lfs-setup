#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (acl) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf acl-2.4.0
tar -xf acl-2.4.0.tar.xz
cd acl-2.4.0

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/acl-2.4.0

make

make install

cd /sources
rm -rf acl-2.4.0
echo "### 240-acl: complete"
