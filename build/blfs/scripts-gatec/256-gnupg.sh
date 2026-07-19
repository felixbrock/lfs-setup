#!/bin/bash
# Generated from BLFS 13.0-systemd (postlfs/gnupg.html) — runs as root
# inside the chroot or on the live LFS system (gnupg batch, 2026-07-17).
# Included book blocks: configure/make + make install, minus makeinfo/html
# doc builds; '&&' chains split.
# DIVERGENCE (AGENT-DESIGN.md #14): --disable-ldap — the book requires
# OpenLDAP for dirmngr's LDAP keyserver support; this machine needs gpg for
# file crypto (backup zips) + future signing, not LDAP keyservers, and we
# don't carry an LDAP stack. GnuTLS (recommended, hkps keyservers) likewise
# absent by choice; add both only if keyserver use ever materializes.
set -euo pipefail
cd /sources/blfs
rm -rf gnupg-2.5.17
tar -xf gnupg-2.5.17.tar.bz2
cd gnupg-2.5.17

mkdir build
cd build

../configure --prefix=/usr        \
             --localstatedir=/var \
             --sysconfdir=/etc    \
             --disable-ldap       \
             --docdir=/usr/share/doc/gnupg-2.5.17
make

make install

gpg --version

cd /sources/blfs
rm -rf gnupg-2.5.17
echo "### 256-gnupg: complete"
