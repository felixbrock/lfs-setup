#!/bin/bash
# Generated from BLFS 13.0-systemd (multimedia/pulseaudio.html) — runs inside chroot as root
# Included book blocks: [0, 1, 2] of 3
# pactl only; daemon NOT enabled (package-list note). Conflict-prevention block from the wireplumber page appended
set -euo pipefail
cd /sources/blfs
rm -rf pulseaudio-17.0
tar -xf pulseaudio-17.0.tar.xz
cd pulseaudio-17.0

mkdir build
cd    build

meson setup --prefix=/usr       \
            --buildtype=release \
            -D database=gdbm    \
            -D doxygen=false    \
            -D bluez5=disabled  \
            -D tests=false      \
            ..
ninja

ninja install

rm /usr/share/dbus-1/system.d/pulseaudio-system.conf

# From BLFS multimedia/wireplumber.html "Configuring": prevent PulseAudio
# from conflicting with pipewire-pulse (run here because /etc/pulse only
# exists after this package). Package-list note: do NOT enable the daemon.
rm -vf /etc/xdg/autostart/pulseaudio.desktop
rm -vf /etc/xdg/Xwayland-session.d/00-pulseaudio-x11
sed -e '$a autospawn = no' -i /etc/pulse/client.conf

cd /sources/blfs
rm -rf pulseaudio-17.0
echo "### 148-pulseaudio: complete"
