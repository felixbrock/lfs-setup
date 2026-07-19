#!/bin/bash
# Shut down the LFS VM cleanly and VERIFY it is gone before returning.
# Exists because ad-hoc checks got this wrong (pgrep comm-name truncation
# reported a live VM as down while the image was being rebuilt, 2026-07-13).
# Exit 0 = no QEMU holds the image. Exit 1 = it does; do NOT touch the image.
set -euo pipefail

PIDFILE=/tmp/lfs-vm.pid

vm_pid() {
  # trust the pidfile only if the pid is alive AND is qemu
  if [ -f "$PIDFILE" ]; then
    local p
    p=$(cat "$PIDFILE")
    if [ -n "$p" ] && [ "$(ps -p "$p" -o comm= 2>/dev/null)" = qemu-system-x86 ]; then
      echo "$p"
      return
    fi
  fi
  # fallback: full-cmdline match (comm alone truncates at 15 chars)
  pgrep -f 'qemu-system-x86_64.*lfs-vm.img' || true
}

PID=$(vm_pid)
if [ -z "$PID" ]; then
  rm -f "$PIDFILE"
  echo "VM not running"
  exit 0
fi

# clean shutdown via SSH as root; tolerate an unreachable guest.
# NOT felix+sudo: sudo needs a tty over SSH and silently fails,
# which forced SIGTERM (unclean guest FS) twice on 2026-07-13.
ssh -p2222 -i ~/.ssh/lfs-vm -o StrictHostKeyChecking=no -o ConnectTimeout=5 \
    root@127.0.0.1 'systemctl poweroff' 2>/dev/null || true

for _ in $(seq 30); do
  kill -0 "$PID" 2>/dev/null || { rm -f "$PIDFILE"; echo "VM shut down"; exit 0; }
  sleep 2
done

echo "VM (pid $PID) did not power off within 60s; sending SIGTERM" >&2
kill "$PID" 2>/dev/null || true
for _ in $(seq 10); do
  kill -0 "$PID" 2>/dev/null || { rm -f "$PIDFILE"; echo "VM terminated"; exit 0; }
  sleep 1
done

echo "VM still alive after SIGTERM — investigate before touching the image" >&2
exit 1
