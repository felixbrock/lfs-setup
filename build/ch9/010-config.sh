#!/bin/bash
# LFS 13.0-systemd chapter 9 system configuration — runs inside chroot.
# NOTE: written from LFS knowledge while linuxfromscratch.org is unreachable
# (host IPv4 outage); to be diffed against the book when it's back.
# Choices mirror the owner's Arch host: locale en_US.UTF-8, keymap uk, tz set in
# ch8 glibc (Europe/London). Hostname deliberately distinct: lfs.
set -euo pipefail

# network: DHCP on any en* interface (QEMU virtio-net shows up as enp*)
mkdir -p /etc/systemd/network
cat > /etc/systemd/network/10-eth-dhcp.network << "EOF"
[Match]
Name=en* eth*

[Network]
DHCP=ipv4

[DHCPv4]
UseDomains=true
EOF

# DNS via systemd-resolved, like the Arch host
ln -sfv /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
systemctl enable systemd-networkd systemd-resolved
# book 9.2: avoid boot delays waiting for links that are down
systemctl disable systemd-networkd-wait-online

# book 9.7: /etc/profile exports the locale into login shells
cat > /etc/profile << "EOF"
# Begin /etc/profile

for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  source /etc/locale.conf

  for i in $(locale); do
    key=${i%=*}
    if [[ -v $key ]]; then
      export $key
    fi
  done
fi

# End /etc/profile
EOF

echo lfs > /etc/hostname

cat > /etc/vconsole.conf << "EOF"
KEYMAP=uk
EOF

cat > /etc/locale.conf << "EOF"
LANG=en_US.UTF-8
EOF

# readline defaults (LFS book chapter 9 standard content)
cat > /etc/inputrc << "EOF"
# Modified by Chet Ramey (chet@ins.cwru.edu)
set horizontal-scroll-mode Off
set meta-flag On
set input-meta On
set convert-meta Off
set output-meta On
set bell-style none
"\eOd": backward-word
"\eOc": forward-word
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert
"\eOH": beginning-of-line
"\eOF": end-of-line
"\e[H": beginning-of-line
"\e[F": end-of-line
EOF

cat > /etc/shells << "EOF"
/bin/sh
/bin/bash
EOF

# VM-phase fstab: single virtio disk, partition 1
cat > /etc/fstab << "EOF"
# file system  mount-point  type   options          dump  fsck order
/dev/vda1      /            ext4   defaults         1     1
EOF

cat > /etc/os-release << "EOF"
NAME="Linux From Scratch"
VERSION="13.0-systemd"
ID=lfs
PRETTY_NAME="Linux From Scratch 13.0-systemd"
VERSION_CODENAME="fbl"
EOF

echo "### 010-config: complete"
