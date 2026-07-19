#!/bin/bash
# Gate D build pipeline (boot chain for real hardware) — runs INSIDE the
# LFS chroot. Same stamp + manifest machinery as the BLFS run-all: logs
# to /sources/logs/gated, file manifests to /var/lib/lfs-pkg/<name>.list.
set -uo pipefail

DIR=/sources/gated-scripts
LOGDIR=/sources/logs/gated
PKGDB=/var/lib/lfs-pkg
mkdir -p "$LOGDIR" "$PKGDB"

[ -d /sources ] || { echo "not inside the LFS chroot"; exit 1; }

manifest() {
  find / -xdev \
       \( -path /sources -o -path /tmp -o -path "$PKGDB" \) -prune \
       -o \( -type f -o -type l \) -cnewer "$LOGDIR/.stamp" -print 2>/dev/null \
    | sort > "$PKGDB/$1.list"
}

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
  touch "$LOGDIR/.stamp"
  if bash "$script" > "$log" 2>&1; then
    manifest "$name"
    touch "$stamp"
    echo "=== $name: OK ($((SECONDS-start))s, $(wc -l < "$PKGDB/$name.list") files) ==="
  else
    echo "=== $name: FAILED after $((SECONDS-start))s — see $log (last 30 lines follow) ==="
    tail -30 "$log"
    exit 1
  fi
done
echo "=== Gate D chain complete ==="
