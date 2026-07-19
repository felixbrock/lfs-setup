#!/bin/bash
# BLFS LVM2 2.03.38 — needed for libdevmapper (cryptsetup) and the dm
# tooling LUKS relies on. Runs inside chroot.
set -euo pipefail
cd /sources/gated
rm -rf LVM2.2.03.38
tar -xf LVM2.2.03.38.tgz
cd LVM2.2.03.38

PATH+=:/usr/sbin
./configure --prefix=/usr \
            --enable-cmdlib \
            --enable-pkgconfig \
            --enable-udev_sync
make
make install
make install_systemd_units

cd /sources/gated
rm -rf LVM2.2.03.38
echo "### 020-lvm2: complete"
