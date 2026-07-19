#!/bin/bash
# Generated from BLFS 13.0-systemd (general/lm-sensors.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
# no sensors-detect blocks on the page (interactive tool is runtime-only)
set -euo pipefail
cd /sources/blfs
rm -rf lm-sensors-3-6-2
tar -xf lm-sensors-3-6-2.tar.gz
cd lm-sensors-3-6-2

make PREFIX=/usr        \
     BUILD_STATIC_LIB=0 \
     MANDIR=/usr/share/man

make PREFIX=/usr        \
     BUILD_STATIC_LIB=0 \
     MANDIR=/usr/share/man install

install -v -m755 -d /usr/share/doc/lm-sensors-3-6-2
cp -rv              README INSTALL doc/* \
                    /usr/share/doc/lm-sensors-3-6-2

cd /sources/blfs
rm -rf lm-sensors-3-6-2
echo "### 211-lm_sensors: complete"
