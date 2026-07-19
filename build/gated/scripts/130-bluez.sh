#!/bin/bash
# BLFS bluez 5.86 — Bluetooth stack (bucket
# E re-promotion for metal). Service enabled: D-Bus activated, inert
# without an adapter (harmless in the VM). Runs inside chroot.
set -euo pipefail
cd /sources/gated
rm -rf bluez-5.86
tar -xf bluez-5.86.tar.xz
cd bluez-5.86

# book fix: avoid bogus adapter powering failure
sed -i '4967,4968d' src/adapter.c

# --disable-obex: OBEX needs libical; not needed for BLE (desk control)
# --disable-manpages: rst2man/docutils not built
./configure --prefix=/usr \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --enable-library \
            --disable-obex \
            --disable-manpages
make
make install
ln -svf ../libexec/bluetooth/bluetoothd /usr/sbin

install -v -dm755 /etc/bluetooth
install -v -m644 src/main.conf /etc/bluetooth/main.conf

systemctl enable bluetooth

cd /sources/gated
rm -rf bluez-5.86
echo "### 130-bluez: complete"
