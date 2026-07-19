#!/bin/bash
# Generated from BLFS 13.0-systemd (general/sysstat.html) — runs inside chroot as root
# Included book blocks: [0, 1, 2, 3] of 5; '&&' chains split into plain statements
# units/timers installed but skipped: 4 (systemctl enable sysstat) per plan — collection service must NOT be enabled
set -euo pipefail
cd /sources/blfs
rm -rf sysstat-12.7.9
tar -xf sysstat-12.7.9.tar.xz
cd sysstat-12.7.9

sa_lib_dir=/usr/lib/sa    \
sa_dir=/var/log/sa        \
conf_dir=/etc/sysstat     \
./configure --prefix=/usr \
            --disable-file-attr
make

make install

install -v -m644 sysstat.service /usr/lib/systemd/system/sysstat.service
install -v -m644 cron/sysstat-collect.service /usr/lib/systemd/system/sysstat-collect.service
install -v -m644 cron/sysstat-collect.timer /usr/lib/systemd/system/sysstat-collect.timer
install -v -m644 cron/sysstat-rotate.service /usr/lib/systemd/system/sysstat-rotate.service
install -v -m644 cron/sysstat-rotate.timer /usr/lib/systemd/system/sysstat-rotate.timer
install -v -m644 cron/sysstat-summary.service /usr/lib/systemd/system/sysstat-summary.service
install -v -m644 cron/sysstat-summary.timer /usr/lib/systemd/system/sysstat-summary.timer

sed -i "/^Also=/d" /usr/lib/systemd/system/sysstat.service

cd /sources/blfs
rm -rf sysstat-12.7.9
echo "### 209-sysstat: complete"
