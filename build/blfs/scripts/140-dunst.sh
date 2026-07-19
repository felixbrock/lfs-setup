#!/bin/bash
# upstream, not in BLFS — make, WAYLAND=0 (per package list) — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf dunst-1.13.2
tar -xf dunst-1.13.2.tar.gz
cd dunst-1.13.2

make WAYLAND=0 PREFIX=/usr

make WAYLAND=0 PREFIX=/usr install

cd /sources/blfs
rm -rf dunst-1.13.2
echo "### 140-dunst: complete"
