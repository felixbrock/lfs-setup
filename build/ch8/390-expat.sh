#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (expat) — runs inside chroot
# Included book blocks: [0, 1, 3] of 5; tolerant: []
# 2026-07-13: 2.7.4 -> 2.8.2 (LFS advisories 13.0-019/065/069, DoS fixes).
# Not in book; upstream tarball, sha256 recorded in commit.
set -euo pipefail
cd /sources
rm -rf expat-2.8.2
tar -xf expat-2.8.2.tar.xz
cd expat-2.8.2

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.8.2

make

make install

cd /sources
rm -rf expat-2.8.2
echo "### 390-expat: complete"
