#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (wheel) — runs inside chroot
# Included book blocks: [0, 1] of 2; tolerant: []
set -euo pipefail
cd /sources
rm -rf wheel-0.46.3
tar -xf wheel-0.46.3.tar.gz
cd wheel-0.46.3

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist wheel

cd /sources
rm -rf wheel-0.46.3
echo "### 540-wheel: complete"
