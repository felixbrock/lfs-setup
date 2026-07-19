#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (jinja2) — runs inside chroot
# Included book blocks: [0, 1] of 2; tolerant: []
set -euo pipefail
cd /sources
rm -rf jinja2-3.1.6
tar -xf jinja2-3.1.6.tar.gz
cd jinja2-3.1.6

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist Jinja2

cd /sources
rm -rf jinja2-3.1.6
echo "### 750-jinja2: complete"
