#!/bin/bash
# Generated from BLFS 13.0-systemd (general/python-modules.html) — runs inside chroot as root
# pip3 wheel/install commands from the Mako section of the page
set -euo pipefail
cd /sources/blfs
rm -rf mako-1.3.10
tar -xf mako-1.3.10.tar.gz
cd mako-1.3.10

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD

pip3 install --no-index --find-links dist --no-user Mako

cd /sources/blfs
rm -rf mako-1.3.10
echo "### 300-mako: complete"
