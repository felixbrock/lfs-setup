#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (flit-core) — runs inside chroot
# Included book blocks: [0, 1] of 2; tolerant: []
set -euo pipefail
cd /sources
rm -rf flit_core-3.12.0
tar -xf flit_core-3.12.0.tar.gz
cd flit_core-3.12.0

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist flit_core

cd /sources
rm -rf flit_core-3.12.0
echo "### 520-flit-core: complete"
