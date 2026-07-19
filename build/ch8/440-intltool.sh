#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (intltool) — runs inside chroot
# Included book blocks: [0, 1, 2, 4] of 5; tolerant: []
set -euo pipefail
cd /sources
rm -rf intltool-0.51.0
tar -xf intltool-0.51.0.tar.gz
cd intltool-0.51.0

sed -i 's:\\\${:\\\$\\{:' intltool-update.in

./configure --prefix=/usr

make

make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO

cd /sources
rm -rf intltool-0.51.0
echo "### 440-intltool: complete"
