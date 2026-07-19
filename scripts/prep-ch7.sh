#!/bin/bash
# LFS 13.0-systemd chapter 7 preparation. Run once as root.
#
# 1. Chowns the LFS tree from lfs to root (book 7.2).
# 2. Installs /usr/local/sbin/lfs-chroot: mounts the virtual kernel
#    filesystems (book 7.3) if needed and enters the chroot (book 7.4).
# 3. Adds a sudoers rule so felix can invoke lfs-chroot without a password.
#
# SECURITY NOTE, read before running: while this rule exists, felix can run
# commands as root inside the chroot. Root inside a chroot with a bound /dev
# is effectively root on the machine. Remove with:
#     rm /etc/sudoers.d/lfs-chroot
set -euo pipefail

LFS=/mnt/lfs

# 7.2 change ownership (book-verbatim, --from lfs makes it idempotent)
chown --from lfs -R root:root $LFS/{usr,var,etc,tools}
case $(uname -m) in
  x86_64) chown --from lfs -R root:root $LFS/lib64 ;;
esac
# $LFS itself too: it becomes / of the chroot AND of the VM image (mkimage
# tars -C / '.', which carries this ownership). Left felix-owned (prep-ch4),
# it made / uid-1000 inside the VM — found 2026-07-13 via systemd-tmpfiles
# "unsafe path transition" during the postgresql build.
chown root:root $LFS

# 7.3 mount points
mkdir -pv $LFS/{dev,proc,sys,run}

# chroot entry wrapper (mount commands book-verbatim, guarded to be idempotent)
cat > /usr/local/sbin/lfs-chroot << 'WRAPPER_EOF'
#!/bin/bash
# Enter the LFS chroot, mounting virtual kernel filesystems first if needed.
# Usage: lfs-chroot                     (interactive shell)
#        lfs-chroot -c 'command'        (run one command)
#        lfs-chroot /sources/foo.sh     (run a script inside the chroot)
set -euo pipefail
LFS=/mnt/lfs

mountpoint -q $LFS/dev  || mount -v --bind /dev $LFS/dev
mountpoint -q $LFS/dev/pts || mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
mountpoint -q $LFS/proc || mount -vt proc proc $LFS/proc
mountpoint -q $LFS/sys  || mount -vt sysfs sysfs $LFS/sys
mountpoint -q $LFS/run  || mount -vt tmpfs tmpfs $LFS/run
if [ -h $LFS/dev/shm ]; then
  install -d -m 1777 $LFS$(realpath /dev/shm)
else
  mountpoint -q $LFS/dev/shm || mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi

exec chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                       \
    TERM="${TERM:-dumb}"             \
    PS1='(lfs chroot) \u:\w\$ '      \
    PATH=/usr/bin:/usr/sbin          \
    MAKEFLAGS="-j$(nproc)"           \
    TESTSUITEFLAGS="-j$(nproc)"      \
    /bin/bash --login "$@"
WRAPPER_EOF
chmod 755 /usr/local/sbin/lfs-chroot

echo 'felix ALL=(root) NOPASSWD: /usr/local/sbin/lfs-chroot' > /etc/sudoers.d/lfs-chroot
chmod 440 /etc/sudoers.d/lfs-chroot
visudo -cf /etc/sudoers.d/lfs-chroot

echo
echo "OK — LFS tree owned by root; 'sudo lfs-chroot' available to felix."
