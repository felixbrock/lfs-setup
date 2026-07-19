#!/bin/bash
# BLFS NetworkManager 1.56.0 — nmcli is the owner's muscle memory (Arch
# runs NM). DEVIATIONS from book: nmtui=false (needs newt; nmcli is
# the requirement), vapi=false (no vala), crypto=nss (no gnutls in
# tier 1/2; nss present). Installed but NOT enabled — the switch from
# systemd-networkd happens deliberately on the live system.
# Runs inside chroot.
set -euo pipefail
cd /sources/gated
rm -rf NetworkManager-1.56.0
tar -xf NetworkManager-1.56.0.tar.xz
cd NetworkManager-1.56.0

grep -rl '^#!.*python$' | xargs -r sed -i '1s/python/&3/'

mkdir build
cd build
meson setup .. \
      --prefix=/usr \
      --buildtype=release \
      -D libaudit=no \
      -D nmtui=false \
      -D ovs=false \
      -D ppp=false \
      -D nbft=false \
      -D selinux=false \
      -D qt=false \
      -D session_tracking=systemd \
      -D nm_cloud_setup=false \
      -D modem_manager=false \
      -D vapi=false \
      -D crypto=nss \
      -D docs=false \
      -D man=false
ninja
ninja install

command -v nmcli > /dev/null

cd /sources/gated
rm -rf NetworkManager-1.56.0
echo "### 120-networkmanager: complete (NOT enabled; networkd stays active)"
