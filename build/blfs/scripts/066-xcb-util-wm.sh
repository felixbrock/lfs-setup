#!/bin/bash
# Generated from BLFS 13.0-systemd (x/xcb-utilities.html) — runs inside chroot as root
# Build commands from the page loop body
# per-package build from the page's loop body (as_root dropped: running as root)
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xcb-util-wm-0.4.2
tar -xf xcb-util-wm-0.4.2.tar.xz
cd xcb-util-wm-0.4.2

./configure $XORG_CONFIG
make

make install

cd /sources/blfs
rm -rf xcb-util-wm-0.4.2
echo "### 066-xcb-util-wm: complete"
