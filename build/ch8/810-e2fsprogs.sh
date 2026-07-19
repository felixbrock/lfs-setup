#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (e2fsprogs) — runs inside chroot
# Included book blocks: [0, 1, 2, 4, 5, 6] of 9; tolerant: []
set -euo pipefail
cd /sources
rm -rf e2fsprogs-1.47.3
tar -xf e2fsprogs-1.47.3.tar.gz
cd e2fsprogs-1.47.3

mkdir -v build
cd       build

../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-elf-shlibs \
             --disable-libblkid  \
             --disable-libuuid   \
             --disable-uuidd     \
             --disable-fsck

make

make install

rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

cd /sources
rm -rf e2fsprogs-1.47.3
echo "### 810-e2fsprogs: complete"
