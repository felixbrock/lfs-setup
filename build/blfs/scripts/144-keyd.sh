#!/bin/bash
# upstream, not in BLFS — make; FORCE_SYSTEMD=1 so the unit installs inside the chroot — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf keyd-2.6.0
tar -xf keyd-2.6.0.tar.gz
cd keyd-2.6.0

make PREFIX=/usr

make PREFIX=/usr FORCE_SYSTEMD=1 install

# package-list UNUSUAL notes: keyd group + enable the service.
# enable fails while the unit is masked (VM policy, 940) — that is intended;
# the mask falls at Gate D on real hardware.
groupadd -f keyd
systemctl enable keyd || echo "144-keyd: enable blocked by VM policy mask (expected pre-Gate-D)"

cd /sources/blfs
rm -rf keyd-2.6.0
echo "### 144-keyd: complete"
