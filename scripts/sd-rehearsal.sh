#!/bin/bash
# Boot the SD-deploy rehearsal image under OVMF (UEFI) headless and prove
# the full chain: GRUB(EFI) -> kernel -> initramfs -> LUKS unlock over
# serial -> systemd -> SSH. Run on the HOST as your user.
# Usage: sd-rehearsal.sh [passphrase]   (default "lfs", matches the
#        rehearsal passfile used by 070-sd-deploy.sh)
set -euo pipefail

IMG=/mnt/lfs/sources/lfs-sd.img
PASS=${1:-lfs}
SERIAL=/tmp/lfs-sd-serial.sock
LOG=/tmp/lfs-sd-serial.log
OVMF=/usr/share/edk2/x64

[ -r "$IMG" ] || { echo "no rehearsal image at $IMG (run 070-sd-deploy.sh first)"; exit 1; }

if [ -f /tmp/lfs-sd.pid ] && kill -0 "$(cat /tmp/lfs-sd.pid)" 2>/dev/null; then
  kill "$(cat /tmp/lfs-sd.pid)"
  sleep 1
fi
rm -f "$SERIAL" "$LOG"
cp "$OVMF/OVMF_VARS.4m.fd" /tmp/lfs-sd-vars.fd

qemu-system-x86_64 -enable-kvm -cpu host -m 2048 -smp 2 \
  -drive if=pflash,format=raw,readonly=on,file="$OVMF/OVMF_CODE.4m.fd" \
  -drive if=pflash,format=raw,file=/tmp/lfs-sd-vars.fd \
  -drive file="$IMG",if=virtio,format=raw \
  -nic user,model=virtio-net-pci,hostfwd=tcp:127.0.0.1:2223-:22 \
  -display none -serial unix:"$SERIAL",server,nowait \
  -daemonize -pidfile /tmp/lfs-sd.pid

python3 - "$SERIAL" "$PASS" "$LOG" << 'EOF'
import socket, sys, time
sock_path, passphrase, log_path = sys.argv[1], sys.argv[2], sys.argv[3]
s = socket.socket(socket.AF_UNIX)
deadline = time.time() + 10
while True:
    try:
        s.connect(sock_path); break
    except OSError:
        if time.time() > deadline: raise
        time.sleep(0.3)
s.settimeout(180)
buf = b""
sent = False
log = open(log_path, "wb")
start = time.time()
while time.time() - start < 180:
    try:
        chunk = s.recv(4096)
    except socket.timeout:
        break
    if not chunk:
        break
    buf += chunk
    log.write(chunk); log.flush()
    if not sent and b"passphrase" in buf.lower():
        time.sleep(0.5)
        s.sendall(passphrase.encode() + b"\n")
        sent = True
        print("[rehearsal] passphrase sent")
    if b"login:" in buf:
        print("[rehearsal] reached login prompt")
        sys.exit(0)
sys.exit(1)
EOF

echo "[rehearsal] checking SSH on :2223"
for i in $(seq 1 30); do
  if ssh -p2223 -i ~/.ssh/lfs-vm -o StrictHostKeyChecking=no \
         -o UserKnownHostsFile=/dev/null -o ConnectTimeout=2 \
         felix@127.0.0.1 'echo SSH-OK; uname -r; findmnt -n -o SOURCE /' 2>/dev/null; then
    echo "[rehearsal] PASSED — full UEFI+GRUB+initramfs+LUKS boot verified"
    exit 0
  fi
  sleep 1
done
echo "[rehearsal] SSH never came up — see $LOG"
exit 1
