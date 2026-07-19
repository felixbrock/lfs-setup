#!/bin/bash
# Generated from BLFS 13.0-systemd (postlfs/linux-pam.html) — runs inside chroot as root
# Included book blocks: [1, 4, 6, 7] of 8
# skipped: 0 (doc sed, needs lynx), 2+3 (test-suite pam setup/teardown), 5 (optional docs tarball)
set -euo pipefail
cd /sources/blfs
rm -rf Linux-PAM-1.7.2
tar -xf Linux-PAM-1.7.2.tar.xz
cd Linux-PAM-1.7.2

mkdir build
cd    build

meson setup ..        \
  --prefix=/usr       \
  --buildtype=release \
  -D docdir=/usr/share/doc/Linux-PAM-1.7.2

ninja

ninja install
chmod -v 4755 /usr/sbin/unix_chkpwd

install -vdm755 /etc/pam.d
cat > /etc/pam.d/system-account << "EOF"
# Begin /etc/pam.d/system-account

account   required    pam_unix.so

# End /etc/pam.d/system-account
EOF

cat > /etc/pam.d/system-auth << "EOF"
# Begin /etc/pam.d/system-auth

auth      required    pam_unix.so

# End /etc/pam.d/system-auth
EOF

cat > /etc/pam.d/system-session << "EOF"
# Begin /etc/pam.d/system-session

session   required    pam_unix.so

# End /etc/pam.d/system-session
EOF

cat > /etc/pam.d/system-password << "EOF"
# Begin /etc/pam.d/system-password

# use yescrypt hash for encryption, use shadow, and try to use any
# previously defined authentication token (chosen password) set by any
# prior module.
password  required    pam_unix.so       yescrypt shadow try_first_pass

# End /etc/pam.d/system-password
EOF

cat > /etc/pam.d/other << "EOF"
# Begin /etc/pam.d/other

auth        required        pam_warn.so
auth        required        pam_deny.so
account     required        pam_warn.so
account     required        pam_deny.so
password    required        pam_warn.so
password    required        pam_deny.so
session     required        pam_warn.so
session     required        pam_deny.so

# End /etc/pam.d/other
EOF

cd /sources/blfs
rm -rf Linux-PAM-1.7.2
echo "### 001-linux-pam: complete"
