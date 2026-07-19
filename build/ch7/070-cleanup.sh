#!/bin/bash
# LFS 13.0-systemd 7.13 cleanup (in-chroot part only)
set -euo pipefail

rm -rf /usr/share/{info,man,doc}/*

find /usr/{lib,libexec} -name \*.la -delete

rm -rf /tools

echo "### 070-cleanup: complete"
