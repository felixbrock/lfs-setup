#!/bin/bash
# Generated from BLFS 13.0-systemd (multimedia/pipewire.html) — runs inside chroot as root
# Included book blocks: [0, 1] of 2
# UNUSUAL note: enable --global pipewire sockets (from wireplumber page config section)
set -euo pipefail
cd /sources/blfs
rm -rf pipewire-1.6.8
tar -xf pipewire-1.6.8.tar.bz2
cd pipewire-1.6.8

mkdir build
cd    build

meson setup ..                 \
      --prefix=/usr            \
      --buildtype=release      \
      -D session-managers="[]"
ninja

ninja install

# From BLFS multimedia/wireplumber.html "Configuring" (split per package
# list: enable the pipewire user sockets here, wireplumber unit in 147)
systemctl enable --global pipewire.socket
systemctl enable --global pipewire-pulse.socket

cd /sources/blfs
rm -rf pipewire-1.6.8
echo "### 146-pipewire: complete"
