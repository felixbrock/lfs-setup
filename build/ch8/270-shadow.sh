#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (shadow) — runs inside chroot
# Included book blocks: [0, 1, 2, 3, 4, 5, 6, 7, 8] of 10; tolerant: []
set -euo pipefail
cd /sources
rm -rf shadow-4.19.3
tar -xf shadow-4.19.3.tar.xz
cd shadow-4.19.3

sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
    -e 's:/var/spool/mail:/var/mail:'                   \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                  \
    -i etc/login.defs

touch /usr/bin/passwd
./configure --sysconfdir=/etc   \
            --disable-static    \
            --with-{b,yes}crypt \
            --without-libbsd    \
            --disable-logind    \
            --with-group-name-max-length=32

make

make exec_prefix=/usr install
make -C man install-man

pwconv

grpconv

mkdir -p /etc/default
useradd -D --gid 999

sed -i '/MAIL/s/yes/no/' /etc/default/useradd

cd /sources
rm -rf shadow-4.19.3
echo "### 270-shadow: complete"
