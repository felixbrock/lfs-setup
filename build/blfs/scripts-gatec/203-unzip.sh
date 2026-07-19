#!/bin/bash
# Replaces Info-ZIP unzip60 (K&R C, unbuildable with GCC 15, dropped from
# BLFS 13.0) with libarchive per BLFS general/libarchive.html; bsdunzip and
# bsdcpio provide unzip/cpio-compatible CLIs.
set -euo pipefail
cd /sources/blfs
rm -rf libarchive-3.8.8
tar -xf libarchive-3.8.8.tar.xz
cd libarchive-3.8.8

./configure --prefix=/usr --disable-static
make

make install

ln -sfv bsdunzip /usr/bin/unzip

cd /sources/blfs
rm -rf libarchive-3.8.8
echo "### 203-unzip: complete"
