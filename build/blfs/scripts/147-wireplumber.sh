#!/bin/bash
# Generated from BLFS 13.0-systemd (multimedia/wireplumber.html) — runs inside chroot as root
# Included book blocks: [0, 1, 2] of 5
# -D system-lua=true is in the book block (matches list note); skipped: 3 (pulseaudio conflict fix, moved to 148 — /etc/pulse exists only after pulseaudio), 4 partly (pipewire sockets enabled in 146)
set -euo pipefail
cd /sources/blfs
rm -rf wireplumber-0.5.13
tar -xf wireplumber-0.5.13.tar.bz2
cd wireplumber-0.5.13

mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release -D system-lua=true ..
ninja

ninja install

mv -v /usr/share/doc/wireplumber{,-0.5.13}

# From BLFS multimedia/wireplumber.html "Configuring"
systemctl enable --global wireplumber

cd /sources/blfs
rm -rf wireplumber-0.5.13
echo "### 147-wireplumber: complete"
