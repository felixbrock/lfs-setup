#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (man-pages) — runs inside chroot
# Included book blocks: [0, 1] of 2; tolerant: []
set -euo pipefail
cd /sources
rm -rf man-pages-6.17
tar -xf man-pages-6.17.tar.xz
cd man-pages-6.17

rm -v man3/crypt*

make -R GIT=false prefix=/usr install

cd /sources
rm -rf man-pages-6.17
echo "### 010-man-pages: complete"
