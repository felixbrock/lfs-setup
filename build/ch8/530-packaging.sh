#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (packaging) — runs inside chroot
# Included book blocks: [0, 1] of 2; tolerant: []
set -euo pipefail
cd /sources
rm -rf packaging-26.0
tar -xf packaging-26.0.tar.gz
cd packaging-26.0

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist packaging

cd /sources
rm -rf packaging-26.0
echo "### 530-packaging: complete"
