#!/bin/bash
# First native-on-LFS batch runner (post metal boot the card IS the system;
# the Arch chroot stays build-env-only and catches up from these same repo
# scripts at its next run-all). Same stamp + manifest machinery as the
# chroot run-alls: logs+stamps under /sources/logs/live, file manifests into
# /var/lib/lfs-pkg/<name>.list.
#
# Usage (root):
#   live-run-all.sh <staging-dir> <script>...
# <staging-dir> holds pre-verified artifacts; each is re-checked against the
# committed ledger here (provenance gate) before staging into /sources/blfs.
set -uo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DIR=/sources/live-scripts
LOGDIR=/sources/logs/live
PKGDB=/var/lib/lfs-pkg

[ "$(. /etc/os-release; echo "$ID")" = "lfs" ] || { echo "not on the LFS system"; exit 1; }
[ "$(id -u)" = "0" ] || { echo "must run as root"; exit 1; }

STAGING=${1:?usage: live-run-all.sh <staging-dir> <script>...}
shift
[ $# -ge 1 ] || { echo "no scripts given"; exit 1; }

mkdir -p /sources/blfs "$DIR" "$LOGDIR" "$PKGDB"

for t in "$STAGING"/*; do
  [ -e "$t" ] || continue   # config-only batches stage no artifacts
  if ! bash "$REPO/scripts/verify-source.sh" "$t"; then
    echo "ABORT: $t failed the provenance gate"
    exit 1
  fi
  cp -f "$t" /sources/blfs/
done

cp -f "$@" "$DIR"/

# manifest(): every file created/modified by the script, by ctime (-cnewer:
# meson-class installers preserve source mtimes). /home, /var/log and the
# DB itself are pruned — agent/journal churn is not package content.
manifest() {
  find / -xdev \
       \( -path /sources -o -path /tmp -o -path /home \
          -o -path /var/log -o -path "$PKGDB" \) -prune \
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

ldconfig
echo "=== live batch complete ==="
