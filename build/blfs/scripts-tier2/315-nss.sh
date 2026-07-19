#!/bin/bash
# Generated from BLFS 13.0-systemd (postlfs/nss.html) — runs inside chroot as root
# 2026-07-19: 3.120.1 -> 3.125 (lfs-config#1: CVE-2026-2781/-6766/-6767/-6772/-12318; BLFS dev book recipe, same patch)
# Included book blocks: [0, 2] of 4; '&&' chains split into plain statements
# standalone patch + book install block (libs, headers, certutil/nss-config/pk12util, nss.pc). skipped: 1 (test suite), 3 (libnssckbi -> p11-kit-trust symlink: p11-kit not installed)
set -euo pipefail
cd /sources/blfs
rm -rf nss-3.125
tar -xf nss-3.125.tar.gz
cd nss-3.125

patch -Np1 -i ../nss-standalone-1.patch

cd nss

make BUILD_OPT=1                      \
  NSPR_INCLUDE_DIR=/usr/include/nspr  \
  USE_SYSTEM_ZLIB=1                   \
  ZLIB_LIBS=-lz                       \
  NSS_ENABLE_WERROR=0                 \
  NSS_USE_SYSTEM_SQLITE=1             \
  $([ $(uname -m) = x86_64 ] && echo USE_64=1)

cd ../dist

install -v -m755 Linux*/lib/*.so              /usr/lib
# 3.125 no longer ships libcrmf.a (dev-book install block dropped it;
# first rerun failed here 2026-07-19 with the 3.120.1 line)
install -v -m644 Linux*/lib/*.chk             /usr/lib

install -v -m755 -d                           /usr/include/nss
cp -v -RL {public,private}/nss/*              /usr/include/nss

install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin

install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig

cd /sources/blfs
rm -rf nss-3.125
echo "### 315-nss: complete"
