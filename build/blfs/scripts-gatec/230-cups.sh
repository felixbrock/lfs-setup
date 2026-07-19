#!/bin/bash
# CUPS (BLFS pst/cups.html) — libcups.so.2 is a hard Brave/Chromium runtime
# dep. Daemon NOT enabled (printing is a Gate D-era decision).
set -euo pipefail
cd /sources/blfs
rm -rf cups-2.4.17
tar -xf cups-2.4.17-source.tar.gz
cd cups-2.4.17

getent passwd lp > /dev/null || \
  useradd -c "Print Service User" -d /var/spool/cups -g lp -s /bin/false -u 9 lp
getent group lpadmin > /dev/null || groupadd -g 19 lpadmin

sed -i 's#@CUPS_HTMLVIEW@#brave#' desktop/cups.desktop.in

sed -i '/& ipp->prev)/s/prev/& \&\& ipp->prev->next == *attr/' cups/ipp.c

./configure --libdir=/usr/lib            \
            --with-rundir=/run/cups      \
            --with-system-groups=lpadmin \
            --with-docdir=/usr/share/cups/doc-2.4.17
make

make install
ln -svnf ../cups/doc-2.4.17 /usr/share/doc/cups-2.4.17

echo "ServerName /run/cups/cups.sock" > /etc/cups/client.conf

cat > /etc/pam.d/cups << "EOF"
# Begin /etc/pam.d/cups

auth    include system-auth
account include system-account
session include system-session

# End /etc/pam.d/cups
EOF

# book's `systemctl enable cups` deliberately SKIPPED (no printer yet)

cd /sources/blfs
rm -rf cups-2.4.17
echo "### 230-cups: complete"
