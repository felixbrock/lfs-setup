#!/bin/bash
# Gate D prerequisite (P3b): pyelftools — build-time dependency of
# systemd's sd-boot/EFI-stub build (087). Pure-python, no runtime users;
# passes the D9 test only as the enabler of D1's bootloader. PyPI sdist,
# ledger-pinned (sha256 from PyPI's published digest).
# Runs inside chroot.
set -euo pipefail
cd /sources/gated

rm -rf pyelftools-0.33
tar -xzf pyelftools-0.33.tar.gz
cd pyelftools-0.33
pip3 install --no-index --no-build-isolation --no-cache-dir .
cd ..
rm -rf pyelftools-0.33

python3 -c "import elftools; print(elftools.__file__)"
echo "### 086-pyelftools: complete"
