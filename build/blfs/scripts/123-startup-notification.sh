#!/bin/bash
# Generated from BLFS 13.0-systemd (x/startup-notification.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
set -euo pipefail
cd /sources/blfs
rm -rf startup-notification-0.12
tar -xf startup-notification-0.12.tar.gz
cd startup-notification-0.12

./configure --prefix=/usr --disable-static
make

make install
install -v -m644 -D doc/startup-notification.txt \
    /usr/share/doc/startup-notification-0.12/startup-notification.txt

cd /sources/blfs
rm -rf startup-notification-0.12
echo "### 123-startup-notification: complete"
