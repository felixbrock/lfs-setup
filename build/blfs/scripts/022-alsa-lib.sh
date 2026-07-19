#!/bin/bash
# Generated from BLFS 13.0-systemd (multimedia/alsa-lib.html) — runs inside chroot as root
# Included book blocks: [0, 2] of 4
# skipped: 1+3 (optional doxygen docs). Install block unpacks alsa-ucm-conf (present in /sources/blfs)
set -euo pipefail
cd /sources/blfs
rm -rf alsa-lib-1.2.16.1
tar -xf alsa-lib-1.2.16.1.tar.bz2
cd alsa-lib-1.2.16.1

./configure
make

make install
tar -C /usr/share/alsa --strip-components=1 -xf ../alsa-ucm-conf-1.2.16.1.tar.bz2

cd /sources/blfs
rm -rf alsa-lib-1.2.16.1
echo "### 022-alsa-lib: complete"
