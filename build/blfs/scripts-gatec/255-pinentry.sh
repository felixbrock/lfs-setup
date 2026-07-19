#!/bin/bash
# Generated from BLFS 13.0-systemd (general/pinentry.html) — runs as root
# inside the chroot or on the live LFS system (gnupg batch, 2026-07-17).
# Included book blocks: [0, 1, 2] of 3; '&&' chains split. The two seds fix
# the book's FLTK detection — harmless here (no FLTK). ncursesw present, so
# this yields pinentry-tty + pinentry-curses and the /usr/bin/pinentry link
# gpg-agent needs for passphrase prompts (gpg -d in a terminal).
set -euo pipefail
cd /sources/blfs
rm -rf pinentry-1.3.2
tar -xf pinentry-1.3.2.tar.bz2
cd pinentry-1.3.2

sed -i "/FLTK 1/s/3/4/" configure
sed -i '14456 s/1.3/1.4/' configure

./configure --prefix=/usr          \
            --enable-pinentry-tty
make

make install

cd /sources/blfs
rm -rf pinentry-1.3.2
echo "### 255-pinentry: complete"
