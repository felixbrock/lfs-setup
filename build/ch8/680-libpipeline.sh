#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (libpipeline) — runs inside chroot
# Included book blocks: [0, 1, 2] of 3; tolerant: []
set -euo pipefail
cd /sources
rm -rf libpipeline-1.5.8
tar -xf libpipeline-1.5.8.tar.gz
cd libpipeline-1.5.8

./configure --prefix=/usr

make

make install

cd /sources
rm -rf libpipeline-1.5.8
echo "### 680-libpipeline: complete"
