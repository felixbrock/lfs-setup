#!/bin/bash
# Generated from BLFS 13.0-systemd (x/xterm.html) — runs inside chroot as root
# Included book blocks: [0, 1, 2] of 3
set -euo pipefail
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
cd /sources/blfs
rm -rf xterm-407
tar -xf xterm-407.tgz
cd xterm-407

sed -i '/v0/{n;s/new:/new:kb=^?:/}' termcap
printf '\tkbs=\\177,\n' >> terminfo

TERMINFO=/usr/share/terminfo \
./configure $XORG_CONFIG     \
            --with-app-defaults=/etc/X11/app-defaults

make

make install

mkdir -pv /usr/share/applications
cp -v *.desktop /usr/share/applications/

cat >> /etc/X11/app-defaults/XTerm << "EOF"
*VT100*locale: true
*VT100*faceName: Monospace
*VT100*faceSize: 10
*backarrowKeyIsErase: true
*ptyInitialErase: true
EOF

cd /sources/blfs
rm -rf xterm-407
echo "### 129-xterm: complete"
