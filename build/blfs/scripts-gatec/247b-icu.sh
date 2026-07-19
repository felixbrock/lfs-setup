#!/bin/bash
# ICU (BLFS general/icu.html) — required by PostgreSQL 18 (default ICU
# collations; chosen over --without-icu so collation/index behavior
# matches the Arch host's postgres). x86-only sed from the book skipped
# (applies to i?86 only).
set -euo pipefail
cd /sources/blfs
rm -rf icu
tar -xf icu4c-78.2-sources.tgz
cd icu/source

./configure --prefix=/usr
make

make install

cd /sources/blfs
rm -rf icu
echo "### 247b-icu: complete"
