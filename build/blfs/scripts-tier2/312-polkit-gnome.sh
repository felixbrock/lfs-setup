#!/bin/bash
# Generated from BLFS 13.0-systemd (postlfs/polkit-gnome.html) — runs inside chroot as root
# Included book blocks: [0, 1, 2, 3] of 4; '&&' chains split into plain statements
# consolidated fixes patch + the book /etc/xdg/autostart entry included
set -euo pipefail
cd /sources/blfs
rm -rf polkit-gnome-0.105
tar -xf polkit-gnome-0.105.tar.xz
cd polkit-gnome-0.105

patch -Np1 -i ../polkit-gnome-0.105-consolidated_fixes-1.patch

./configure --prefix=/usr
make

make install

mkdir -p /etc/xdg/autostart
cat > /etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop << "EOF"
[Desktop Entry]
Name=PolicyKit Authentication Agent
Comment=PolicyKit Authentication Agent
Exec=/usr/libexec/polkit-gnome-authentication-agent-1
Terminal=false
Type=Application
Categories=
NoDisplay=true
OnlyShowIn=GNOME;XFCE;Unity;
AutostartCondition=GNOME3 unless-session gnome
EOF

cd /sources/blfs
rm -rf polkit-gnome-0.105
echo "### 312-polkit-gnome: complete"
