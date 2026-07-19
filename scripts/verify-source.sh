#!/bin/bash
# Deterministic provenance gate — no artifact is staged into /sources or
# built unless it passes this check. Policy: PROVENANCE.md.
#
# Usage:
#   verify-source.sh <file>                  known artifact: must match the ledger
#   verify-source.sh <file> --md5 <hash>     new artifact: verify book/upstream md5,
#                                            then record in the ledger
#   verify-source.sh <file> --sha256 <hash>  new artifact: verify upstream sha256,
#                                            then record in the ledger
#
# Exit 0 = artifact is exactly the bytes this repo has built from (or a
# new artifact that matched an independently published hash and is now
# pinned). Any other outcome is a hard failure.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
# LFS_LEDGER override (three-repo split): the LIVE ledger is the
# instance's SBOM and lives in the private ops repo; machine.env sets
# LFS_LEDGER there. Default = this repo's ledger (blueprint
# reproducers build their own from empty).
LEDGER="${LFS_LEDGER:-$REPO/ops/sources-sha256.txt}"

FILE=${1:?usage: verify-source.sh <file> [--md5|--sha256 <hash>]}
MODE=${2:-}
HASH=${3:-}

[ -r "$FILE" ] || { echo "FAIL: cannot read $FILE"; exit 1; }
base=$(basename "$FILE")
sha=$(sha256sum "$FILE" | awk '{print $1}')

# ledger paths are /sources-relative; match on basename (artifact names
# are versioned and unique)
entry=$(awk -v b="$base" '{n=split($2,p,"/"); if (p[n]==b) print}' "$LEDGER" | head -1)

if [ -n "$entry" ]; then
  lhash=$(echo "$entry" | awk '{print $1}')
  if [ "$lhash" = "$sha" ]; then
    echo "PASS: $base matches the ledger"
    exit 0
  fi
  echo "FAIL: $base sha256 MISMATCH against the committed ledger"
  echo "  ledger: $lhash"
  echo "  actual: $sha"
  echo "  Do NOT stage this file. Investigate before touching the ledger."
  exit 1
fi

case "$MODE" in
  --md5)
    actual=$(md5sum "$FILE" | awk '{print $1}')
    if [ "$actual" != "$HASH" ]; then
      echo "FAIL: md5 mismatch (expected $HASH, got $actual)"
      exit 1
    fi ;;
  --sha256)
    if [ "$sha" != "$HASH" ]; then
      echo "FAIL: sha256 mismatch (expected $HASH, got $sha)"
      exit 1
    fi ;;
  *)
    echo "FAIL: $base is not in the ledger and no independently published"
    echo "  hash was provided (--md5 from the LFS/BLFS book, or --sha256"
    echo "  from the upstream release page). Refusing."
    exit 1 ;;
esac

echo "$sha  new/$base" >> "$LEDGER"
echo "PASS: $base verified against the provided hash and pinned in the"
echo "  ledger — commit ops/sources-sha256.txt with the change."
