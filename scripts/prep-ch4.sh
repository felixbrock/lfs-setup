#!/bin/bash
# LFS 13.0-systemd chapter 4 preparation. Run once as root.
# Creates the $LFS skeleton, the unprivileged 'lfs' build user, its build
# environment, and a sudoers rule letting felix act as lfs (NOT as root).
set -euo pipefail

LFS=/mnt/lfs

# 4.2 minimal directory layout
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}
for i in bin lib sbin; do
  [ -L $LFS/$i ] || ln -sv usr/$i $LFS/$i
done
case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac
mkdir -pv $LFS/tools

# 4.3 lfs user (locked password; access via sudo -u lfs only)
getent group lfs  > /dev/null || groupadd lfs
getent passwd lfs > /dev/null || useradd -s /bin/bash -g lfs -m -k /dev/null lfs

chown -v lfs $LFS/{usr{,/*},var,etc,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac
chown -v lfs $LFS/sources

# 4.4 build environment for the lfs user (verbatim from the book,
# plus MAKEFLAGS for the 20-core host)
cat > /home/lfs/.bash_profile << "PROFILE_EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
PROFILE_EOF

cat > /home/lfs/.bashrc << "BASHRC_EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export MAKEFLAGS=-j$(nproc)
BASHRC_EOF

chown lfs:lfs /home/lfs/.bash_profile /home/lfs/.bashrc

# Deviation from book: do NOT move /etc/bash.bashrc — that would alter the
# host's interactive shells. Builds run under 'env -i' so it never applies.

# Allow felix to run commands as the unprivileged lfs user without a
# password (root still requires a password as usual).
echo 'felix ALL=(lfs) NOPASSWD: ALL' > /etc/sudoers.d/lfs-build
chmod 440 /etc/sudoers.d/lfs-build
visudo -cf /etc/sudoers.d/lfs-build

echo
echo "OK — LFS skeleton at $LFS, lfs user ready, felix may 'sudo -u lfs'."
