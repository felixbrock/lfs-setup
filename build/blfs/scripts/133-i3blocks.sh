#!/bin/bash
# upstream, not in BLFS — autotools, autogen.sh first (per package list) — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf i3blocks-1.5
tar -xf i3blocks-1.5.tar.gz
cd i3blocks-1.5

./autogen.sh
./configure --prefix=/usr --sysconfdir=/etc
make

# -j1: the install-data-local rule renames the bash-completion file and
# races against its own install under parallel make
make -j1 install

cd /sources/blfs
rm -rf i3blocks-1.5
echo "### 133-i3blocks: complete"
