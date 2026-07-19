#!/bin/bash
# Gate D prerequisite (P3b, AGENT-DESIGN D1): rebuild systemd 260.1 with
# -D bootloader=enabled — adds sd-boot (the EFI boot manager binary),
# the EFI stub, and systemd-bless-boot (the boot-counting "mark good"
# half). Same meson configuration as the 003 PAM rebuild plus the one
# option; the installed tree is otherwise identical, so this is a safe
# in-place reinstall (same version, superset of files).
# Requires 086-pyelftools. Runs inside chroot.
set -euo pipefail
cd /sources/blfs
rm -rf systemd-260.1
tar -xf /sources/systemd-260.1.tar.gz
cd systemd-260.1

rm -fv /usr/lib/systemd/system/systemd-update-utmp-runlevel.service

sed -i -e 's/GROUP="render"/GROUP="video"/' \
       -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in

mkdir build
cd    build

meson setup ..                 \
      --prefix=/usr            \
      --buildtype=release      \
      -D default-dnssec=no     \
      -D firstboot=false       \
      -D install-tests=false   \
      -D ldconfig=false        \
      -D man=auto              \
      -D sysusers=false        \
      -D rpmmacrosdir=no       \
      -D homed=disabled        \
      -D mode=release          \
      -D pam=enabled           \
      -D pamconfdir=/etc/pam.d \
      -D dev-kvm-mode=0660     \
      -D nobody-group=nogroup  \
      -D sysupdate=disabled    \
      -D ukify=disabled        \
      -D bootloader=enabled    \
      -D sbat-distro=lfs       \
      -D sbat-distro-summary='Linux From Scratch 13.0-systemd' \
      -D sbat-distro-pkgname=systemd \
      -D sbat-distro-version=260.1   \
      -D sbat-distro-url='https://www.linuxfromscratch.org/' \
      -D docdir=/usr/share/doc/systemd-260.1

ninja

ninja install

cd /sources/blfs
rm -rf systemd-260.1

# the two artifacts this rebuild exists for
test -f /usr/lib/systemd/boot/efi/systemd-bootx64.efi
test -x /usr/lib/systemd/systemd-bless-boot
bootctl --version | head -1
echo "### 087-systemd-bootloader: complete"
