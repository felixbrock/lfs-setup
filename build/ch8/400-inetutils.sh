#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (inetutils) — runs inside chroot
# Included book blocks: [0, 1, 2, 4, 5] of 6; tolerant: []
set -euo pipefail
cd /sources
rm -rf inetutils-2.8
tar -xf inetutils-2.8.tar.gz
cd inetutils-2.8

sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c

./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers

make

make install

mv -v /usr/{,s}bin/ifconfig

cd /sources
rm -rf inetutils-2.8
echo "### 400-inetutils: complete"
