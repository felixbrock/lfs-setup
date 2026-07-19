#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (markupsafe) — runs inside chroot
# Included book blocks: [0, 1] of 2; tolerant: []
set -euo pipefail
cd /sources
rm -rf markupsafe-3.0.3
tar -xf markupsafe-3.0.3.tar.gz
cd markupsafe-3.0.3

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist Markupsafe

cd /sources
rm -rf markupsafe-3.0.3
echo "### 740-markupsafe: complete"
