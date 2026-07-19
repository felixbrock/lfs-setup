#!/bin/bash
# Generated from BLFS 13.0-systemd (basicnet/rsync.html) — runs inside chroot as root
# Included book blocks: [1, 2, 5] of 10; '&&' chains split into plain statements
# 3.4.3: the 3.4.1 security patch is integrated upstream (sa-13.0-083). skipped: 0 (rsyncd daemon user), 3+4+6 (docs/tests), 7+8+9 (daemon config + units). DEVIATION: removed --disable-xxhash — xxhash is installed by 215 and wanted (worklist step 6)
set -euo pipefail
cd /sources/blfs
rm -rf rsync-3.4.3
tar -xf rsync-3.4.3.tar.gz
cd rsync-3.4.3


./configure --prefix=/usr    \
            --without-included-zlib
make

make install

cd /sources/blfs
rm -rf rsync-3.4.3
echo "### 216-rsync: complete"
