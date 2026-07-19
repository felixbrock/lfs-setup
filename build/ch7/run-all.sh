#!/bin/bash
# Runs all chapter 7 steps in order INSIDE the LFS chroot, logging each.
set -uo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
LOGDIR=/sources/logs/ch7
mkdir -p "$LOGDIR"

[ "$(whoami 2>/dev/null || echo root)" = root ] || { echo "must run as root in chroot"; exit 1; }
[ -d /sources ] || { echo "not inside the LFS chroot"; exit 1; }

for script in "$DIR"/[0-9]*.sh; do
  name=$(basename "$script" .sh)
  log="$LOGDIR/$name.log"
  stamp="$LOGDIR/$name.done"
  if [ -e "$stamp" ]; then
    echo "=== $name: already done, skipping ==="
    continue
  fi
  echo "=== $name: starting ==="
  start=$SECONDS
  if bash "$script" > "$log" 2>&1; then
    touch "$stamp"
    echo "=== $name: OK ($((SECONDS-start))s) ==="
  else
    echo "=== $name: FAILED after $((SECONDS-start))s — see $log (last 30 lines follow) ==="
    tail -30 "$log"
    exit 1
  fi
done
echo "=== chapter 7 complete ==="
