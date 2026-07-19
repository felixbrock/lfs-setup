#!/bin/bash
# Generated from BLFS 13.0-systemd (general/accountsservice.html) — runs inside chroot as root
# Included book blocks: [0, 3, 4, 5, 6, 7] of 8; '&&' chains split into plain statements
# -D vapi=false added per plan (no vala). blocks 0 and 4 kept — the book applies them unconditionally (build breaks without them); skipped: 1+2 (test-suite-only tweaks). block 7 installs the polkit adm-group admin rule (book config)
set -euo pipefail
cd /sources/blfs
rm -rf accountsservice-23.13.9
tar -xf accountsservice-23.13.9.tar.xz
cd accountsservice-23.13.9

mv tests/dbusmock{,-tests}

mkdir build
cd    build

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D admin_group=adm  \
      -D vapi=false

grep 'print_indent'     ../subprojects/mocklibc-1.0/src/netgroup.c \
     | sed 's/ {/;/' >> ../subprojects/mocklibc-1.0/src/netgroup.h
sed -i '1i#include <stdio.h>'                                      \
    ../subprojects/mocklibc-1.0/src/netgroup.h

ninja

ninja install

cat > /etc/polkit-1/rules.d/40-adm.rules << "EOF"
polkit.addAdminRule(function(action, subject) {
   return ["unix-group:adm"];
   });
EOF

cd /sources/blfs
rm -rf accountsservice-23.13.9
echo "### 311-accountsservice: complete"
