#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (sqlite) — runs inside chroot
# Included book blocks: [1, 2, 3] of 5; tolerant: []
set -euo pipefail
cd /sources
rm -rf sqlite-autoconf-3510200
tar -xf sqlite-autoconf-3510200.tar.gz
cd sqlite-autoconf-3510200

./configure --prefix=/usr     \
            --disable-static  \
            --enable-fts{4,5} \
            CPPFLAGS="-D SQLITE_ENABLE_COLUMN_METADATA=1 \
                      -D SQLITE_ENABLE_UNLOCK_NOTIFY=1   \
                      -D SQLITE_ENABLE_DBSTAT_VTAB=1     \
                      -D SQLITE_SECURE_DELETE=1"

make LDFLAGS.rpath=""

make install

cd /sources
rm -rf sqlite-autoconf-3510200
echo "### 500-sqlite: complete"
