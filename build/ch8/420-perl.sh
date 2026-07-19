#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (perl) — runs inside chroot
# Included book blocks: [0, 1, 2, 4] of 5; tolerant: []
set -euo pipefail
cd /sources
rm -rf perl-5.42.2
tar -xf perl-5.42.2.tar.xz
cd perl-5.42.2

export BUILD_ZLIB=False
export BUILD_BZIP2=0

sh Configure -des                                          \
             -D prefix=/usr                                \
             -D vendorprefix=/usr                          \
             -D privlib=/usr/lib/perl5/5.42/core_perl      \
             -D archlib=/usr/lib/perl5/5.42/core_perl      \
             -D sitelib=/usr/lib/perl5/5.42/site_perl      \
             -D sitearch=/usr/lib/perl5/5.42/site_perl     \
             -D vendorlib=/usr/lib/perl5/5.42/vendor_perl  \
             -D vendorarch=/usr/lib/perl5/5.42/vendor_perl \
             -D man1dir=/usr/share/man/man1                \
             -D man3dir=/usr/share/man/man3                \
             -D pager="/usr/bin/less -isR"                 \
             -D useshrplib                                 \
             -D usethreads

make

make install
unset BUILD_ZLIB BUILD_BZIP2

cd /sources
rm -rf perl-5.42.2
echo "### 420-perl: complete"
