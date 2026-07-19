#!/bin/bash
# Generated from BLFS 13.0-systemd (postlfs/efibootmgr.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2; '&&' chains split into plain statements
# IMPROVISED: builds efivar-39 (+book patch) first — efibootmgr hard-requires it and it was missing from the worklist
set -euo pipefail
# --- efivar-39 first (required library for efibootmgr, from postlfs/efivar.html;
# --- not listed separately in the worklist, folded in here)
cd /sources/blfs
rm -rf efivar-39
tar -xf efivar-39.tar.gz
cd efivar-39

patch -Np1 -i ../efivar-39-upstream_fixes-1.patch

make ENABLE_DOCS=0

make install ENABLE_DOCS=0 LIBDIR=/usr/lib
install -vm644 docs/efivar.1 /usr/share/man/man1
install -vm644 docs/*.3      /usr/share/man/man3
/sbin/ldconfig

cd /sources/blfs
rm -rf efivar-39

# --- efibootmgr-18 (postlfs/efibootmgr.html)
cd /sources/blfs
rm -rf efibootmgr-18
tar -xf efibootmgr-18.tar.gz
cd efibootmgr-18

make EFIDIR=LFS EFI_LOADER=grubx64.efi

make install EFIDIR=LFS

cd /sources/blfs
rm -rf efibootmgr-18
echo "### 221-efibootmgr: complete"
