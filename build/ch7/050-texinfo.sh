#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 7 (texinfo) — runs inside chroot
set -euo pipefail
cd /sources
rm -rf texinfo-7.2
tar -xf texinfo-7.2.tar.xz
cd texinfo-7.2

./configure --prefix=/usr

make

make install

cd /sources
rm -rf texinfo-7.2
echo "### 050-texinfo: complete"
