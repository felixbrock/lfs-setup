#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (lz4) — runs inside chroot
# Included book blocks: [0, 2] of 3; tolerant: []
set -euo pipefail
cd /sources
rm -rf lz4-1.10.0
tar -xf lz4-1.10.0.tar.gz
cd lz4-1.10.0

make BUILD_STATIC=no PREFIX=/usr

make BUILD_STATIC=no PREFIX=/usr install

cd /sources
rm -rf lz4-1.10.0
echo "### 070-lz4: complete"
