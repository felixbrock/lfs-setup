#!/bin/bash
# Canonical installed-package inventory, derived from the repo's build
# scripts (the repo IS the system). Output: "name version" per line.
# Host-side, read-only; used by security-check.sh and /lfs-sweep.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

grep -rhoE '^(tar -xf|rm -rf) (\.\./)?[A-Za-z0-9._+-]+-[0-9][A-Za-z0-9._]*' \
    "$REPO"/build/ch8/*.sh \
    "$REPO"/build/blfs/scripts/*.sh \
    "$REPO"/build/blfs/scripts-gatec/*.sh \
    "$REPO"/build/blfs/scripts-post/*.sh \
    "$REPO"/build/blfs/scripts-tier2/*.sh \
    "$REPO"/build/gated/scripts/*.sh 2>/dev/null \
  | sed 's/^tar -xf //;s/^rm -rf //;s|^\.\./||;s/\.tar\..*$//;s/\.t[gx]z$//;s/\.src$//' \
  | sed -E 's/^(.*)-([0-9][0-9A-Za-z._]*)$/\1 \2/' \
  | sort -u

# the kernel is built from ch9, not ch8
grep -hoE 'linux-[0-9.]+\.tar' "$REPO"/build/ch9/020-kernel.sh 2>/dev/null \
  | head -1 | sed -E 's/linux-([0-9.]+)\.tar/linux \1/'

# upstream static tool binaries in /usr/local/bin (scripts-post): distro
# trackers know these names, so tiers 1/1c monitor them like sources.
# The suffix set deliberately excludes the /opt blobs (-linux-x64, .tgz,
# .deb) — those are tier 1b's domain (binary-check.sh).
grep -rhoE '/sources/blfs/[A-Za-z0-9._-]+\.tar\.gz' \
    "$REPO"/build/blfs/scripts-post/*.sh 2>/dev/null \
  | sed 's|.*/||' \
  | sed -nE 's/^([A-Za-z0-9._-]+)-v?([0-9][0-9.]*)-(linux_amd64|linux64|x86_64-unknown-linux-(musl|gnu))\.tar\.gz$/\1 \2/p' \
  | sort -u
