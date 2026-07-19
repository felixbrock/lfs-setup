#!/bin/bash
# Generated from BLFS 13.0-systemd (general/git.html) — runs inside chroot as root
# Included book blocks: [0, 3, 6] of 9; '&&' chains split into plain statements
# skipped: 1+2+4+5 (asciidoc-built docs), 7+8 (htmldocs tarball). block 6 kept: installs the PRE-BUILT git-manpages tarball (no asciidoc needed)
set -euo pipefail
cd /sources/blfs
rm -rf git-2.53.0
tar -xf git-2.53.0.tar.xz
cd git-2.53.0

./configure --prefix=/usr                   \
            --with-gitconfig=/etc/gitconfig \
            --with-python=python3           \
            --with-libpcre2
make

make perllibdir=/usr/lib/perl5/5.42/site_perl install

tar -xf ../git-manpages-2.53.0.tar.xz \
    -C /usr/share/man --no-same-owner --no-overwrite-dir

cd /sources/blfs
rm -rf git-2.53.0
echo "### 213-git: complete"
