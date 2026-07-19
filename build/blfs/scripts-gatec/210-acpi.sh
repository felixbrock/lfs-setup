#!/bin/bash
# not in BLFS (acpid is a different package) — upstream sourceforge acpiclient, autotools — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf acpi-1.7
tar -xf acpi-1.7.tar.gz
cd acpi-1.7

./configure --prefix=/usr
make

make install

cd /sources/blfs
rm -rf acpi-1.7
echo "### 210-acpi: complete"
