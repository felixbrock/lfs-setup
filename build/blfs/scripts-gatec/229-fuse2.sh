#!/bin/bash
# libfuse 2.9.9 (fuse2 for AppImages) — upstream GitHub release, autotools, old-BLFS recipe (init script diverted to /tmp and removed); CFLAGS -std=gnu17 guards 2019-era C against the GCC-15 C23 default — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf fuse-2.9.9
tar -xf fuse-2.9.9.tar.gz
cd fuse-2.9.9

# glibc 2.34+ declares closefrom(); rename fuse's private one
sed -i 's/\bclosefrom\b/fuse_priv_closefrom/g' util/ulockmgr_server.c

./configure --prefix=/usr --disable-static \
            INIT_D_PATH=/tmp/init.d CFLAGS="-g -O2 -std=gnu17"
make

make install
rm -rf /tmp/init.d

cd /sources/blfs
rm -rf fuse-2.9.9
echo "### 229-fuse2: complete"
