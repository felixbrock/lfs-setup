#!/bin/bash
# Generated verbatim from LFS 13.0-systemd chapter 5 (linux-headers)
set -euo pipefail
cd "$LFS/sources"
rm -rf linux-6.18.10
tar -xf linux-6.18.10.tar.xz
cd linux-6.18.10

make mrproper

make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr

cd "$LFS/sources"
rm -rf linux-6.18.10
echo "### 30-linux-headers: complete"
