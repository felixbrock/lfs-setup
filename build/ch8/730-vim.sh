#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (vim) — runs inside chroot
# Included book blocks: [0, 1, 2, 5, 6, 7, 8] of 10; tolerant: []
set -euo pipefail
cd /sources
rm -rf vim-9.2.0782
tar -xf vim-9.2.0782.tar.gz
cd vim-9.2.0782

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

./configure --prefix=/usr

make

make install

ln -sfv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sfv vim.1 $(dirname $L)/vi.1
done

ln -sfv ../vim/vim92/doc /usr/share/doc/vim-9.2.0782

cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF

cd /sources
rm -rf vim-9.2.0782
echo "### 730-vim: complete"
