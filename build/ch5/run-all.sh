#!/bin/bash
# Runs all chapter 5 package builds in order, logging each.
# Must run as the lfs user with the book environment already sourced.
set -uo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
LOGDIR="$LFS/sources/logs/ch5"
mkdir -p "$LOGDIR"

[ "$(whoami)" = lfs ] || { echo "must run as lfs"; exit 1; }
[ -n "${LFS_TGT:-}" ]  || { echo "environment not sourced"; exit 1; }

for script in "$DIR"/[0-9]*.sh; do
  name=$(basename "$script" .sh)
  log="$LOGDIR/$name.log"
  stamp="$LOGDIR/$name.done"
  if [ -e "$stamp" ]; then
    echo "=== $name: already done, skipping ==="
    continue
  fi
  echo "=== $name: starting $(date -u +%H:%M:%S) ==="
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
echo "=== chapter 5 complete ==="
