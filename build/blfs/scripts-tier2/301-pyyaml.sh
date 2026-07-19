#!/bin/bash
# Generated from BLFS 13.0-systemd (general/python-modules.html) — runs inside chroot as root
# pip3 wheel/install commands from the PyYAML section of the page
set -euo pipefail
cd /sources/blfs
rm -rf pyyaml-6.0.3
tar -xf pyyaml-6.0.3.tar.gz
cd pyyaml-6.0.3

pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD

pip3 install --no-index --find-links dist --no-user PyYAML

cd /sources/blfs
rm -rf pyyaml-6.0.3
echo "### 301-pyyaml: complete"
