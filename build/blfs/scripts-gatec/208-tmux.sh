#!/bin/bash
# not in BLFS 13.0 — upstream GitHub release, autotools (needs libevent 207 + ncurses) — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf tmux-3.6b
tar -xf tmux-3.6b.tar.gz
cd tmux-3.6b

./configure --prefix=/usr
make

make install

cd /sources/blfs
rm -rf tmux-3.6b
echo "### 208-tmux: complete"
