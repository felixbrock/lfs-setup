#!/bin/bash
# Gate A boot test — run on the HOST as felix. Boots the LFS image with
# direct kernel boot, captures the serial console, and checks the Gate A
# markers. Powers itself off via the gatea-check service in the image.
set -euo pipefail

IMG=/mnt/lfs/sources/lfs-vm.img
KERNEL=/mnt/lfs/boot/vmlinuz-6.18.38-lfs-13.0-systemd
LOG="${1:-/tmp/lfs-gatea-serial.log}"

ACCEL=()
[ -w /dev/kvm ] && ACCEL=(-enable-kvm -cpu host)

timeout 300 qemu-system-x86_64 \
  "${ACCEL[@]}" \
  -m 4096 -smp 4 \
  -drive file="$IMG",if=virtio,format=raw \
  -kernel "$KERNEL" \
  -append "root=/dev/vda1 rw console=ttyS0" \
  -nic user,model=virtio-net-pci \
  -display none -serial file:"$LOG" \
  -no-reboot

echo "=== serial log tail ==="
tail -40 "$LOG"
echo "======================="
grep -q 'GATEA-BEGIN' "$LOG" || { echo "GATE A: boot never reached the check service"; exit 1; }
echo "GATE A: reached multi-user.target and ran the self-check (see log above)"
