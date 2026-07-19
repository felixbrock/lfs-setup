#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 7 (gettext) — runs inside chroot
set -euo pipefail
cd /sources
rm -rf gettext-1.0
tar -xf gettext-1.0.tar.xz
cd gettext-1.0

./configure --disable-shared

make

cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

cd /sources
rm -rf gettext-1.0
echo "### 020-gettext: complete"
