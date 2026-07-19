#!/bin/bash
# BLFS libaio 0.3.113 — LVM2 dependency. Runs inside chroot.
set -euo pipefail
cd /sources/gated
rm -rf libaio-0.3.113
tar -xf libaio-0.3.113.tar.gz
cd libaio-0.3.113

# book: skip installing the static library
sed -i '/install.*libaio.a/s/^/#/' src/Makefile

make
make install

cd /sources/gated
rm -rf libaio-0.3.113
echo "### 010-libaio: complete"
