#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (less) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf less-692
tar -xf less-692.tar.gz
cd less-692

./configure --prefix=/usr --sysconfdir=/etc

make

make install

cd /sources
rm -rf less-692
echo "### 410-less: complete"
