#!/bin/bash
# Generated from BLFS 13.0-systemd (postlfs/openssh.html) — runs inside chroot as root
# Included book blocks: [0, 1, 2] of 8; '&&' chains split into plain statements
# sshd user/group + build + install; systemd unit installed from blfs-systemd-units (make install-sshd) but NOT enabled. skipped: 3+5 (optional sshd_config hardening), 4 (interactive ssh-keygen), 6 (PAM/sshd config, optional)
set -euo pipefail

cd /sources/blfs
rm -rf openssh-10.4p1
tar -xf openssh-10.4p1.tar.gz
cd openssh-10.4p1

install -v -g sys -m700 -d /var/lib/sshd

getent group sshd > /dev/null || groupadd -g 50 sshd
getent passwd sshd > /dev/null || \
useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd

# --with-pam: SSH logins must create logind sessions (pam_systemd) so
# systemd --user starts and PipeWire's user sockets exist over SSH.
./configure --prefix=/usr                            \
            --sysconfdir=/etc/ssh                    \
            --with-pam                               \
            --with-privsep-path=/var/lib/sshd        \
            --with-default-path=/usr/local/bin:/usr/bin \
            --with-superuser-path=/usr/sbin:/usr/bin \
            --with-pid-dir=/run
make

make install
install -v -m755    contrib/ssh-copy-id /usr/bin

install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1
install -v -m755 -d /usr/share/doc/openssh-10.4p1
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-10.4p1

# Install the sshd systemd unit from the blfs-systemd-units package
# (postlfs/openssh.html: "make install-sshd"); do not enable it.
cd /sources/blfs
rm -rf blfs-systemd-units-20251204
tar -xf blfs-systemd-units-20251204.tar.xz
cd blfs-systemd-units-20251204
make install-sshd
cd /sources/blfs
rm -rf blfs-systemd-units-20251204

# PAM session wiring for sshd (BLFS optional block, adopted deliberately:
# SSH logins must create logind sessions so systemd --user services run)
cat > /etc/pam.d/sshd << "PAMEOF"
# Begin /etc/pam.d/sshd
auth      include   system-auth
account   include   system-account
password  include   system-password
session   include   system-session
# End /etc/pam.d/sshd
PAMEOF
grep -q "^UsePAM" /etc/ssh/sshd_config || echo "UsePAM yes" >> /etc/ssh/sshd_config

cd /sources/blfs
rm -rf openssh-10.4p1
echo "### 214-openssh: complete"
