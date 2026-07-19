#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 7 (util-linux) — runs inside chroot
set -euo pipefail
cd /sources
rm -rf util-linux-2.41.3
tar -xf util-linux-2.41.3.tar.xz
cd util-linux-2.41.3

mkdir -pv /var/lib/hwclock

./configure --libdir=/usr/lib     \
            --runstatedir=/run    \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-static      \
            --disable-liblastlog2 \
            --without-python      \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.41.3

make

make install

cd /sources
rm -rf util-linux-2.41.3
echo "### 060-util-linux: complete"
