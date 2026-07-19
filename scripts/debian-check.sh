#!/bin/bash
# Tier-1c security check: cross-reference the Debian security tracker's
# full JSON dump (sid branch) against our inventory. Second independent
# triage lens: catches fixes Arch already ships (tier-1 blind spot for
# source builds) without waiting for an LFS advisory (tier-2 lag).
# Proven 2026-07-15 on its first run: found the systemd-260 local
# privilege-escalation set (CVE-2026-40224/40225/40226) that tiers 1
# and 2 both missed.
# Network: security-tracker.debian.org (one ~80MB JSON fetch).
# Kernel is skipped by policy — tracked via LTS point release (tier 1b).
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
CACHE="${1:-/tmp/lfs-debcheck-$(date +%Y%m%d)}"
mkdir -p "$CACHE"
JSON="$CACHE/debian-sec.json"

if [ ! -s "$JSON" ]; then
  curl -sm180 --retry 3 --retry-delay 5 --retry-all-errors \
    "https://security-tracker.debian.org/tracker/data/json" -o "$JSON" \
    || { echo "--- FETCH FAILURE: debian tracker unreachable — tier 1c BLIND"; exit 0; }
fi

bash "$REPO/scripts/lfs-inventory.sh" > "$CACHE/inventory.txt"

python3 - "$JSON" "$CACHE/inventory.txt" "$CACHE" << 'EOF'
import json, re, sys
d = json.load(open(sys.argv[1]))
CUTOFF = 2025  # only CVEs from the last ~2 years; older ones are
               # settled by tier 1 / the watching list

inv = {}
for line in open(sys.argv[2]):
    p = line.strip().rsplit(' ', 1)
    if len(p) == 2:
        inv[p[0].lower()] = p[1]

# our-name -> debian source package for known mismatches; default =
# lowercase. Curate when the unmapped file grows.
alias = {
    'linux-pam': 'pam', 'python': 'python3.14', 'glib': 'glib2.0',
    'xml-parser': 'libxml-parser-perl', 'gtk': 'gtk+3.0',
    'fd': 'rust-fd-find',
}

def vt(v):
    v = v.split(':')[-1].split('-')[0].split('+')[0].split('~')[0]
    return [int(x) for x in re.findall(r'\d+', v)][:4]

agg, watching, unmapped = {}, [], []
for our, ver in inv.items():
    if our == 'linux':
        continue
    dn = alias.get(our, our)
    if dn not in d:
        unmapped.append(f"{our} ({dn})")
        continue
    for cve, info in d[dn].items():
        if not cve.startswith('CVE-2') or int(cve[4:8]) < CUTOFF:
            continue
        sid = info.get('releases', {}).get('sid')
        if not sid:
            continue
        urg = sid.get('urgency', '?')
        if sid['status'] == 'open' and urg not in ('unimportant', 'not yet assigned'):
            watching.append(f"{our} {ver} {cve} open-in-sid urgency={urg}")
        elif sid['status'] == 'resolved':
            fv = sid.get('fixed_version', '0')
            if fv == '0' or not vt(fv):
                continue  # unaffected / unparsable
            if vt(ver) < vt(fv):
                # '~rc' uploads: the fix exists at that base version, but
                # confirm a stable upstream release >= it before acting
                tag = '(rc-fix)' if '~' in fv else ''
                if urg == 'unimportant':
                    tag += '(unimportant)'
                a = agg.setdefault(our, {'maxfix': fv, 'cves': []})
                a['cves'].append(cve + tag)
                if vt(fv) > vt(a['maxfix']):
                    a['maxfix'] = fv

for k in sorted(agg, key=lambda k: -len(agg[k]['cves'])):
    a = agg[k]
    print(f"{k} {inv[k]} debian-fix={a['maxfix']} CVES={len(a['cves'])} {','.join(a['cves'][:6])}")
for w in sorted(set(watching)):
    print("WATCH", w)
if unmapped:
    open(f"{sys.argv[3]}/unmapped.txt", 'w').write('\n'.join(sorted(unmapped)) + '\n')
    print(f"--- unmapped (curate alias map, see {sys.argv[3]}/unmapped.txt): {len(unmapped)}")
print(f"--- cache: {sys.argv[3]}")
EOF
