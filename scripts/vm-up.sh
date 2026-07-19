#!/bin/bash
# Boot the LFS VM with SSH forwarded to localhost:2222.
# Usage: vm-up.sh              headless (background, prints when SSH is ready)
#        vm-up.sh --display    graphical GTK window (daily-driver smoke tests)
#        ssh -p2222 -i ~/.ssh/lfs-vm -o StrictHostKeyChecking=no felix@127.0.0.1
# Audio: guest HDA device is always present; sound only reaches the host if
# a QEMU host audio backend is installed (qemu-audio-pipewire) — see
# `qemu-system-x86_64 -audiodev help`. Falls back to the null backend.
set -euo pipefail

IMG=/mnt/lfs/sources/lfs-vm.img
KERNEL=/mnt/lfs/boot/vmlinuz-6.18.38-lfs-13.0-systemd

DISPLAY_ARGS=(-display none)
if [ "${1:-}" = "--display" ]; then
  DISPLAY_ARGS=(-display gtk)
fi

AUDIODEV=(-audiodev none,id=snd0)
if qemu-system-x86_64 -audiodev help 2>/dev/null | grep -qx pipewire; then
  AUDIODEV=(-audiodev pipewire,id=snd0)
fi

# pidfile check (pgrep -f self-matches its own invocation via the image path)
if [ -f /tmp/lfs-vm.pid ] && kill -0 "$(cat /tmp/lfs-vm.pid)" 2>/dev/null; then
  echo "VM already running (pid $(cat /tmp/lfs-vm.pid))"; exit 0
fi

qemu-system-x86_64 -enable-kvm -cpu host -m 4096 -smp 4 \
  -drive file="$IMG",if=virtio,format=raw \
  -kernel "$KERNEL" \
  -append "root=/dev/vda1 rw console=ttyS0" \
  -vga std \
  "${AUDIODEV[@]}" -device intel-hda -device hda-duplex,audiodev=snd0 \
  -nic user,model=virtio-net-pci,hostfwd=tcp:127.0.0.1:2222-:22 \
  "${DISPLAY_ARGS[@]}" -serial file:/tmp/lfs-vm-serial.log \
  -daemonize -pidfile /tmp/lfs-vm.pid

for i in $(seq 1 60); do
  if ssh -p2222 -i ~/.ssh/lfs-vm -o StrictHostKeyChecking=no \
         -o UserKnownHostsFile=/dev/null -o ConnectTimeout=2 \
         felix@127.0.0.1 true 2>/dev/null; then
    echo "VM up, SSH ready on 127.0.0.1:2222"
    exit 0
  fi
  sleep 1
done
echo "VM did not become SSH-reachable in 60s (serial: /tmp/lfs-vm-serial.log)"
exit 1
