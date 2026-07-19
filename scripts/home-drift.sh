#!/bin/bash
# Detect UNSEEN user-level configuration: top-level entries in ~/.config
# and dotfiles/dotdirs in $HOME that are neither deployed from the config
# repo's dotfiles staging nor in the accepted baseline. The /etc git
# snapshot covers system config; this covers the home side, where
# track-everything is impractical (caches churn) — so instead the
# baseline pins the known world and anything NEW flags for triage:
# either promote it into $LFS_CONFIG/dotfiles (worth keeping) or append
# it to the baseline (ignorable). Run from /lfs-status step 7; --accept
# rewrites the baseline to the current state after triage.
set -euo pipefail

: "${LFS_CONFIG:?export LFS_CONFIG (private config repo) first}"
BASELINE="$LFS_CONFIG/system/home-baseline.txt"

current() {
  for e in "$HOME"/.config/* "$HOME"/.[!.]*; do
    b=$(basename "$e")
    case "$e" in
      "$HOME"/.config/*) echo ".config/$b" ;;
      *) [ "$b" = ".config" ] || echo "$b" ;;
    esac
  done | sort -u
}

if [ "${1:-}" = "--accept" ]; then
  current > "$BASELINE"
  echo "baseline rewritten: $(wc -l < "$BASELINE") entries (commit $LFS_CONFIG)"
  exit 0
fi

[ -f "$BASELINE" ] || { echo "no baseline — run: $0 --accept"; exit 1; }

TRACKED=$(cd "$LFS_CONFIG/dotfiles" 2>/dev/null && ls -A || true)
UNSEEN=$(comm -23 <(current) <(sort -u "$BASELINE" <(echo "$TRACKED")))

if [ -n "$UNSEEN" ]; then
  echo "UNSEEN user config (promote to $LFS_CONFIG/dotfiles or --accept):"
  echo "$UNSEEN"
  exit 1
fi
echo "home config: no unseen entries"
