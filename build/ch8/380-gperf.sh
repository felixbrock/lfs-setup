#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (gperf) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf gperf-3.3
tar -xf gperf-3.3.tar.gz
cd gperf-3.3

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.3

make

make install

cd /sources
rm -rf gperf-3.3
echo "### 380-gperf: complete"
