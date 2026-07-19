#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (xml-parser) — runs inside chroot
# Included book blocks: [0, 1, 3] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf XML-Parser-2.54
tar -xf XML-Parser-2.54.tar.gz
cd XML-Parser-2.54

perl Makefile.PL

make

make install

cd /sources
rm -rf XML-Parser-2.54
echo "### 430-xml-parser: complete"
