#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (texinfo) — runs inside chroot
# Included book blocks: [0, 1, 2, 4] of 7; tolerant: []
set -euo pipefail
cd /sources
rm -rf texinfo-7.2
tar -xf texinfo-7.2.tar.xz
cd texinfo-7.2

sed 's/! $output_file eq/$output_file ne/' -i tp/Texinfo/Convert/*.pm

./configure --prefix=/usr

make

make install

cd /sources
rm -rf texinfo-7.2
echo "### 720-texinfo: complete"
