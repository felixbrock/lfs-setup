#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (tcl) — runs inside chroot
# Included book blocks: [0, 1, 3, 4, 5, 6, 7] of 9; tolerant: []
set -euo pipefail
cd /sources
rm -rf tcl8.6.17
tar -xf tcl8.6.17-src.tar.gz
cd tcl8.6.17

SRCDIR=$(pwd)
cd unix
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --disable-rpath

make

sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|"  \
    -i tclConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.12|/usr/lib/tdbc1.1.12|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.12/generic|/usr/include|"     \
    -e "s|$SRCDIR/pkgs/tdbc1.1.12/library|/usr/lib/tcl8.6|"  \
    -e "s|$SRCDIR/pkgs/tdbc1.1.12|/usr/include|"             \
    -i pkgs/tdbc1.1.12/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/itcl4.3.4|/usr/lib/itcl4.3.4|" \
    -e "s|$SRCDIR/pkgs/itcl4.3.4/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/itcl4.3.4|/usr/include|"            \
    -i pkgs/itcl4.3.4/itclConfig.sh

unset SRCDIR

make install 
chmod 644 /usr/lib/libtclstub8.6.a

chmod -v u+w /usr/lib/libtcl8.6.so

make install-private-headers

ln -sfv tclsh8.6 /usr/bin/tclsh

mv -v /usr/share/man/man3/{Thread,Tcl_Thread}.3

cd /sources
rm -rf tcl8.6.17
echo "### 150-tcl: complete"
