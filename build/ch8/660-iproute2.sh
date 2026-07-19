#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (iproute2) — runs inside chroot
# Included book blocks: [0, 1, 2] of 4; tolerant: []
set -euo pipefail
cd /sources
rm -rf iproute2-6.18.0
tar -xf iproute2-6.18.0.tar.xz
cd iproute2-6.18.0

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

make NETNS_RUN_DIR=/run/netns

make SBINDIR=/usr/sbin install

cd /sources
rm -rf iproute2-6.18.0
echo "### 660-iproute2: complete"
