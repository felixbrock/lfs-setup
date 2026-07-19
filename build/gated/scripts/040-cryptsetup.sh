#!/bin/bash
# BLFS cryptsetup 2.8.4 — LUKS2 for the Gate D encrypted root. Runs inside chroot.
set -euo pipefail
cd /sources/gated
rm -rf cryptsetup-2.8.4
tar -xf cryptsetup-2.8.4.tar.xz
cd cryptsetup-2.8.4

./configure --prefix=/usr \
            --disable-ssh-token \
            --disable-asciidoc
make
make install

cryptsetup --version

cd /sources/gated
rm -rf cryptsetup-2.8.4
echo "### 040-cryptsetup: complete"
