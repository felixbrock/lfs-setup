#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (coreutils) — runs inside chroot
# Included book blocks: [0, 1, 2, 8, 9] of 10; tolerant: []
set -euo pipefail
cd /sources
rm -rf coreutils-9.10
tar -xf coreutils-9.10.tar.xz
cd coreutils-9.10

patch -Np1 -i ../coreutils-9.10-i18n-1.patch

autoreconf -fv
automake -af
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr

make

make install

mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8

cd /sources
rm -rf coreutils-9.10
echo "### 590-coreutils: complete"
