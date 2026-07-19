#!/bin/bash
# not in BLFS — upstream GitHub release, autotools — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf bash-completion-2.16.0
tar -xf bash-completion-2.16.0.tar.xz
cd bash-completion-2.16.0

./configure --prefix=/usr --sysconfdir=/etc
make

make install

cd /sources/blfs
rm -rf bash-completion-2.16.0
echo "### 206-bash-completion: complete"
