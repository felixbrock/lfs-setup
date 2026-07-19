#!/bin/bash
# File::ShareDir::Install (CPAN, pure perl) — new configure-time dependency
# of XML-Parser >= 2.54 (2026-07-13 security batch, advisory 13.0-020).
# sha256 recorded in the batch commit.
set -euo pipefail
cd /sources
rm -rf File-ShareDir-Install-0.14
tar -xf File-ShareDir-Install-0.14.tar.gz
cd File-ShareDir-Install-0.14

perl Makefile.PL

make

make install

cd /sources
rm -rf File-ShareDir-Install-0.14
echo "### 425-file-sharedir-install: complete"
