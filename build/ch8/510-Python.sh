#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (Python) — runs inside chroot
# Included book blocks: [0, 1, 3, 4] of 6; tolerant: []
set -euo pipefail
cd /sources
rm -rf Python-3.14.6
tar -xf Python-3.14.6.tar.xz
cd Python-3.14.6

# sa-13.0-137: post-3.14.6 security fixes (CVE-2026-11972/11940/12003)
patch -Np1 -i ../Python-3.14.6-consolidated_fixes-1.patch

./configure --prefix=/usr          \
            --enable-shared        \
            --with-system-expat    \
            --enable-optimizations \
            --without-static-libpython

make

make install

cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

cd /sources
rm -rf Python-3.14.6
echo "### 510-Python: complete"
