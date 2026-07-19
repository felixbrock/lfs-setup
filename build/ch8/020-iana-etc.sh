#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (iana-etc) — runs inside chroot
# Included book blocks: [0] of 1; tolerant: []
set -euo pipefail
cd /sources
rm -rf iana-etc-20260202
tar -xf iana-etc-20260202.tar.gz
cd iana-etc-20260202

cp -v services protocols /etc

cd /sources
rm -rf iana-etc-20260202
echo "### 020-iana-etc: complete"
