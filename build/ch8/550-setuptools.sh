#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (setuptools) — runs inside chroot
# Included book blocks: [0, 1] of 2; tolerant: []
set -euo pipefail
cd /sources
rm -rf setuptools-82.0.0
tar -xf setuptools-82.0.0.tar.gz
cd setuptools-82.0.0

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist setuptools

cd /sources
rm -rf setuptools-82.0.0
echo "### 550-setuptools: complete"
