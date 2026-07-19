#!/bin/bash
# thermald 2.5.12 (Intel thermal daemon) — the owner added it to Arch
# 2026-07-14; metal-relevant (laptop thermal management). Upstream
# github.com/intel/thermal_daemon, autotools. Needs kernel v12
# (POWERCAP/INTEL_RAPL/INTEL_POWERCLAMP/INT340X). Runs inside chroot.
set -euo pipefail
cd /sources/gated
rm -rf thermal_daemon-2.5.12
tar -xf thermal_daemon-2.5.12.tar.gz
cd thermal_daemon-2.5.12

# no gtk-doc in this system: stub the macro, drop the docs subdir, and
# run the autogen steps manually (gtkdocize skipped)
sed -i 's/^GTK_DOC_CHECK.*/AM_CONDITIONAL([ENABLE_GTK_DOC],[false])\nAM_CONDITIONAL([GTK_DOC_BUILD_HTML],[false])\nAM_CONDITIONAL([GTK_DOC_BUILD_PDF],[false])\nAM_CONDITIONAL([GTK_DOC_USE_LIBTOOL],[false])\nAM_CONDITIONAL([GTK_DOC_USE_REBASE],[false])/' configure.ac
sed -i 's/^SUBDIRS = . docs data/SUBDIRS = . data/' Makefile.am
printf 'CLEANFILES =\nEXTRA_DIST =\n' > gtk-doc.make

aclocal --install
autoreconf --install
./configure --prefix=/usr \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --with-systemdsystemunitdir=/usr/lib/systemd/system
make
make install

systemctl enable thermald

cd /sources/gated
rm -rf thermal_daemon-2.5.12
echo "### 150-thermald: complete"
