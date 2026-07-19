#!/bin/bash
# Runs all tier-2 package builds INSIDE the LFS chroot, logging each and
# recording a file manifest per package into /var/lib/lfs-pkg/<name>.list.
set -uo pipefail

DIR=/sources/tier2-scripts
LOGDIR=/sources/logs/tier2
PKGDB=/var/lib/lfs-pkg
mkdir -p "$LOGDIR" "$PKGDB"

[ -d /sources ] || { echo "not inside the LFS chroot"; exit 1; }

# Xorg build environment (BLFS "Xorg-7 Introduction")
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

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
echo "=== tier 2 complete ==="
