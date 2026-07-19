#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (zstd) — runs inside chroot
# Included book blocks: [0, 2, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf zstd-1.5.7
tar -xf zstd-1.5.7.tar.gz
cd zstd-1.5.7

make prefix=/usr

make prefix=/usr install

rm -v /usr/lib/libzstd.a

cd /sources
rm -rf zstd-1.5.7
echo "### 080-zstd: complete"
