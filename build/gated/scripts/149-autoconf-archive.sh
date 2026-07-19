#!/bin/bash
# autoconf-archive 2024.10.16 (GNU) — m4 macro collection; thermald's
# configure uses AX_CHECK_COMPILE_FLAG. Pure macro install. Runs inside chroot.
set -euo pipefail
cd /sources/gated
rm -rf autoconf-archive-2024.10.16
tar -xf autoconf-archive-2024.10.16.tar.xz
cd autoconf-archive-2024.10.16

./configure --prefix=/usr
make
make install

test -e /usr/share/aclocal/ax_check_compile_flag.m4

cd /sources/gated
rm -rf autoconf-archive-2024.10.16
echo "### 149-autoconf-archive: complete"
