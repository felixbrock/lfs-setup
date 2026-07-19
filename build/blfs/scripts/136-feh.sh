#!/bin/bash
# Generated from BLFS 13.0-systemd (xsoft/feh.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
# DEVIATION: curl=0 — libcurl (recommended by the book) is not in LFS/tier-1
set -euo pipefail
cd /sources/blfs
rm -rf feh-3.11.3
tar -xf feh-3.11.3.tar.bz2
cd feh-3.11.3

sed -i "s:doc/feh:&-3.11.3:" config.mk
make PREFIX=/usr curl=0

make PREFIX=/usr curl=0 install

cd /sources/blfs
rm -rf feh-3.11.3
echo "### 136-feh: complete"
