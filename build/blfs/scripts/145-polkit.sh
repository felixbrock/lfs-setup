#!/bin/bash
# Generated from BLFS 13.0-systemd (postlfs/polkit.html) — runs inside chroot as root
# Included book blocks: [0, 1, 2, 3] of 4
# polkitd user/group 27 per book block 0. DEVIATION: -D man=false (libxslt/docbook not installed)
set -euo pipefail
cd /sources/blfs
rm -rf polkit-127
tar -xf polkit-127.tar.gz
cd polkit-127

groupadd -fg 27 polkitd
useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
        -g polkitd -s /bin/false polkitd

mkdir build
cd    build

meson setup ..                   \
      --prefix=/usr              \
      --buildtype=release        \
      -D man=false                \
      -D session_tracking=logind \
      -D tests=true

ninja

ninja install

# Package-list note: polkit PAM file. polkit-127 installs its own
# /etc/pam.d/polkit-1 via meson when built with PAM support (the BLFS 13.0
# page has no manual PAM block); create the classic BLFS one only if absent.
if [ ! -e /etc/pam.d/polkit-1 ]; then
cat > /etc/pam.d/polkit-1 << "EOF"
# Begin /etc/pam.d/polkit-1

auth     include        system-auth
account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/polkit-1
EOF
fi

cd /sources/blfs
rm -rf polkit-127
echo "### 145-polkit: complete"
