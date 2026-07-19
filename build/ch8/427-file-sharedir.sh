#!/bin/bash
# File::ShareDir (CPAN, pure perl) — hard runtime requirement of
# XML-Parser >= 2.54 (Expat.pm line 16); without it every XML::Parser
# consumer dies at compile time (2026-07-13 security batch).
set -euo pipefail
cd /sources
rm -rf File-ShareDir-1.118
tar -xf File-ShareDir-1.118.tar.gz
cd File-ShareDir-1.118

perl Makefile.PL

make

make install

cd /sources
rm -rf File-ShareDir-1.118
echo "### 427-file-sharedir: complete"
