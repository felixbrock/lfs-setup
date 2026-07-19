#!/bin/bash
# Generated from BLFS 13.0-systemd (postlfs/sudo.html) — runs inside chroot as root
# Included book blocks: [0, 1, 2, 3] of 4; '&&' chains split into plain statements
# blocks: build, install, /etc/sudoers.d/00-sudo, /etc/pam.d/sudo. The PAM file block is KEPT: Linux-PAM is installed so sudo builds with PAM support and would hit the deny-all "other" policy without it
set -euo pipefail
cd /sources/blfs
rm -rf sudo-1.9.17p2
tar -xf sudo-1.9.17p2.tar.gz
cd sudo-1.9.17p2

./configure --prefix=/usr         \
            --libexecdir=/usr/lib \
            --with-secure-path    \
            --with-env-editor     \
            --docdir=/usr/share/doc/sudo-1.9.17p2 \
            --with-passprompt="[sudo] password for %p: "
make

make install

cat > /etc/sudoers.d/00-sudo << "EOF"
Defaults secure_path="/usr/sbin:/usr/bin"
%wheel ALL=(ALL) ALL
EOF

cat > /etc/pam.d/sudo << "EOF"
# Begin /etc/pam.d/sudo

# include the default auth settings
auth      include     system-auth

# include the default account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session defaults
session   include     system-session

# End /etc/pam.d/sudo
EOF
chmod 644 /etc/pam.d/sudo

cd /sources/blfs
rm -rf sudo-1.9.17p2
echo "### 202-sudo: complete"
