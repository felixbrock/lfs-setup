#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (procps-ng) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf procps-ng-4.0.6
tar -xf procps-ng-4.0.6.tar.xz
cd procps-ng-4.0.6

./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-4.0.6 \
            --disable-static                        \
            --disable-kill                          \
            --enable-watch8bit                      \
            --with-systemd

make

make install

cd /sources
rm -rf procps-ng-4.0.6
echo "### 790-procps-ng: complete"
