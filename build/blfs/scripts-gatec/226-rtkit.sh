#!/bin/bash
# not in BLFS — upstream GitHub archive, meson; D-Bus-activated (no systemctl enable needed); enables PipeWire realtime scheduling — runs inside chroot as root
set -euo pipefail
cd /sources/blfs
rm -rf rtkit-0.13
tar -xf rtkit-0.13.tar.gz
cd rtkit-0.13

mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

# runtime user/group rtkit-daemon drops privileges to (idempotent)
getent group  rtkit > /dev/null || groupadd -r rtkit
getent passwd rtkit > /dev/null || useradd -r -g rtkit -d /proc -s /bin/false -c "RealtimeKit" rtkit

cd /sources/blfs
rm -rf rtkit-0.13
echo "### 226-rtkit: complete"
