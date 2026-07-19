#!/bin/bash
# Class::Inspector (CPAN, pure perl) — dependency of File::ShareDir, which
# XML-Parser >= 2.54 hard-requires at runtime (2026-07-13 security batch).
set -euo pipefail
cd /sources
rm -rf Class-Inspector-1.36
tar -xf Class-Inspector-1.36.tar.gz
cd Class-Inspector-1.36

perl Makefile.PL

make

make install

cd /sources
rm -rf Class-Inspector-1.36
echo "### 426-class-inspector: complete"
