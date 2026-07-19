#!/bin/bash
# upstream, not in BLFS — header-only — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf uthash-2.4.0
tar -xf uthash-2.4.0.tar.gz
cd uthash-2.4.0

install -v -Dm644 src/*.h -t /usr/include

cd /sources/blfs
rm -rf uthash-2.4.0
echo "### 142-uthash: complete"
