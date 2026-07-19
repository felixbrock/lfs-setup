#!/bin/bash
# Build a bootable raw disk image of the LFS system — runs inside chroot
# (root there can losetup/mount; everything stays under /sources).
# Layout: 40G sparse raw, DOS label, one bootable ext4 partition (/dev/vda1
# in QEMU). First boots use QEMU direct-kernel; GRUB comes later.
set -euo pipefail

IMG=/sources/lfs-vm.img

# start fresh each run
umount /mnt 2>/dev/null || true
losetup -j "$IMG" | cut -d: -f1 | while read -r l; do losetup -d "$l"; done
rm -f "$IMG"

truncate -s 40G "$IMG"
LOOP=$(losetup -fP --show "$IMG")
trap 'umount /mnt 2>/dev/null || true; losetup -d "$LOOP" 2>/dev/null || true' EXIT

echo 'type=83, bootable' | sfdisk "$LOOP"
mkfs.ext4 -q "${LOOP}p1"
mount "${LOOP}p1" /mnt

# copy the system, excluding virtual filesystems, build area, and mount point
tar -cpf - --exclude=./sources --exclude=./mnt --exclude=./dev \
           --exclude=./proc --exclude=./sys --exclude=./run \
           --exclude=./tmp -C / . | tar -xpf - -C /mnt

# recreate excluded skeleton directories
mkdir -p /mnt/{dev,proc,sys,run,mnt,tmp,sources}
chmod 1777 /mnt/tmp

# VM service policy — asserted on EVERY image build. Package build scripts
# enable their own services, and security rebuilds re-run those scripts while
# the scripts-post policy stays stamp-skipped; on 2026-07-15 that silently
# re-enabled keyd/postgresql/redis/cups/docker.service against recorded
# intent. This block is the always-runs backstop. Recorded intent:
#   keyd            masked   (double-remap under host keyd; unmask at Gate D)
#   postgresql      disabled (installed, start on demand)
#   redis           disabled (installed, start on demand)
#   cups            disabled (built for libcups only, e.g. brave)
#   docker.service  disabled (socket-activated: docker.socket stays enabled)
systemctl --root=/mnt mask keyd
systemctl --root=/mnt disable postgresql redis cups.service cups.path docker.service
systemctl --root=/mnt enable docker.socket
# agent-actions.log append-only policy (988): tar cannot carry the +a
# inode flag into the image — re-assert it here like the service policy
touch /mnt/var/log/agent-actions.log
chown root:1001 /mnt/var/log/agent-actions.log
chmod 664 /mnt/var/log/agent-actions.log
chattr +a /mnt/var/log/agent-actions.log

# Gate A self-check (only when GATEA=1): on first boot, report failed units
# + network to the serial console, then power off.
if [ "${GATEA:-0}" = 1 ]; then
cat > /mnt/etc/systemd/system/gatea-check.service << "EOF"
[Unit]
Description=Gate A automated boot verification
Wants=network-online.target
After=multi-user.target network-online.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'sleep 5; echo GATEA-BEGIN; echo "-- failed units:"; systemctl --failed --no-legend; echo "-- network:"; networkctl list --no-legend; ip -4 addr show; echo "-- dns:"; resolvectl status | head -20; echo GATEA-END; systemctl poweroff'
StandardOutput=journal+console

[Install]
WantedBy=multi-user.target
EOF
ln -sf /etc/systemd/system/gatea-check.service \
      /mnt/etc/systemd/system/multi-user.target.wants/gatea-check.service
fi

umount /mnt
losetup -d "$LOOP"
trap - EXIT
chown 1000:1000 "$IMG"   # felix on the host, so QEMU can read/write it
echo "### 030-mkimage: complete ($(du -h --apparent-size "$IMG" | cut -f1) apparent, $(du -h "$IMG" | cut -f1) real)"
