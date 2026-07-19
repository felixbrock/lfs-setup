#!/bin/bash
# Generated from LFS 13.0-systemd chapter 8 (systemd) — runs inside chroot
# Included book blocks: [0, 1, 2, 4, 5, 6, 7] of 8; tolerant: []
set -euo pipefail
cd /sources
rm -rf systemd-260.1
tar -xf systemd-260.1.tar.gz
cd systemd-260.1

sed -e 's/GROUP="render"/GROUP="video"/' \
    -e 's/GROUP="sgx", //'               \
    -i rules.d/50-udev-default.rules.in

mkdir -p build
cd       build

meson setup ..                \
      --prefix=/usr           \
      --buildtype=release     \
      -D default-dnssec=no    \
      -D firstboot=false      \
      -D install-tests=false  \
      -D ldconfig=false       \
      -D sysusers=false       \
      -D rpmmacrosdir=no      \
      -D homed=disabled       \
      -D man=disabled         \
      -D mode=release         \
      -D pamconfdir=no        \
      -D dev-kvm-mode=0660    \
      -D nobody-group=nogroup \
      -D sysupdate=disabled   \
      -D ukify=disabled       \
      -D docdir=/usr/share/doc/systemd-260.1

ninja

ninja install

tar -xf ../../systemd-man-pages-260.1.tar.xz \
    --no-same-owner --strip-components=1     \
    -C /usr/share/man

systemd-machine-id-setup

systemctl preset-all

cd /sources
rm -rf systemd-260.1
echo "### 760-systemd: complete"
