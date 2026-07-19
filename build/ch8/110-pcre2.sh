#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (pcre2) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf pcre2-10.47
tar -xf pcre2-10.47.tar.bz2
cd pcre2-10.47

./configure --prefix=/usr                       \
            --docdir=/usr/share/doc/pcre2-10.47 \
            --enable-unicode                    \
            --enable-jit                        \
            --enable-pcre2-16                   \
            --enable-pcre2-32                   \
            --enable-pcre2grep-libz             \
            --enable-pcre2grep-libbz2           \
            --enable-pcre2test-libreadline      \
            --disable-static

make

make install

cd /sources
rm -rf pcre2-10.47
echo "### 110-pcre2: complete"
