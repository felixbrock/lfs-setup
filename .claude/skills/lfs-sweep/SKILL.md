---
name: lfs-sweep
description: Security/release sweep for the LFS system — tier 1 queries the Arch security tracker for the full inventory, tier 2 LFS/BLFS advisories, tier 3 upstream releases. Produces a prioritized digest. Use on schedule or when asked "anything need updating?".
---

Three tiers, cheapest and freshest first. Tiers 1, 1b, 1c, and 2 run
on a schedule in the cloud routine (details in the private config
repo: $LFS_CONFIG/ops/routine-daily-seccheck.md); tier 3's release
sweep runs less frequently, as a local-session task.

1. **Arch security tracker** (primary, near-real-time): run
   `scripts/security-check.sh` — queries security.archlinux.org for every
   package in `scripts/lfs-inventory.sh` output (name map inside the
   script; curate it when "UNMAPPED" appears). One line per package with
   open CVEs + a JSON cache for triage.
   TRIAGE RULES (proven 2026-07-13):
   - Arch "Vulnerable" describes ARCH's shipped version, not ours. Always
     compare OUR version against the CVE's fixed version (NVD/upstream)
     before calling it actionable — pam CVE-2025-6020 was a false positive
     (fixed 1.7.1, we ran 1.7.2).
   - Ancient open CVEs (no upstream fix exists; Arch keeps them open too,
     e.g. wget CVE-2021-31879) are not actionable by upgrade — list once
     under "watching", don't re-report every run.
   - Actionable = a released version/patch exists that we lack. That
     subset goes to /lfs-upgrade (or a batch).
   WATCHING LIST (mirror of the cloud routine prompt — update both):
   - No fix released upstream: coreutils CVE-2025-5278, giflib
     CVE-2020-23922 (STILL open at 6.1.3 — the 6.x bump fixed other
     CVEs), grub (8 legacy, bootloader unused), openssl CVE-2025-4575 +
     CVE-2022-2068, perl CVE-2025-40909/CVE-2021-36770/CVE-2020-16156,
     systemd CVE-2025-4598, wget CVE-2021-31879, nasm CVE-2020-18974,
     linux kernel legacy set (13 pre-2022).
   - Verified NOT affected at our versions (recheck only if our version
     changes): libxml2 CVE-2025-49794/49795/49796 + CVE-2025-6170
     (fixed 2.14.5, ours 2.15.3), Linux-PAM CVE-2025-6020 (fixed 1.7.1,
     ours 1.7.2), alsa-lib CVE-2026-25068 (affects <=1.2.15.2),
     fuse CVE-2026-33150/33179 (libfuse 3.18.0-3.18.2 io_uring only;
     ours is fuse2 2.9.9, no io_uring).
1b. **Binary blobs + kernel lag** (scheduled): run `scripts/binary-check.sh`
   — pinned versions (parsed from the install scripts) vs latest
   releases (Arch repos/AUR + kernel.org) for brave, vscode, slack, gh,
   docker, node, tofu, caddy, mise, cloudflared, discord, gcloud,
   chrome, the /usr/local/bin static tools (fzf/ripgrep/micro/fd —
   these also sit in the source inventory for tiers 1/1c), and the
   kernel LTS branch. For blobs no CVE tracker covers (brave is not in
   Arch's repos at all) currency is the control. Brave/chrome LAG =
   actionable priority 1; other Chromium shells actionable past ~a
   month; CLI tools only if the gap has a security fix; kernel is
   go/no-go for the owner, never remote. pinned=UNKNOWN = unversioned
   artifact in the repo — pin it at that tool's next update.
   The same script then queries OSV.dev for every PyPI package in
   ops/pypi-tools.txt (tier 1b-py: uv tool envs — user-level installs
   outside every distro tracker). VULN lines: triage like tier 1
   (compare OUR version to the advisory's fixed version). After any
   uv install/upgrade regenerate the pin list:
   `scripts/coverage-check.sh --pypi` and commit the diff.
1c. **Debian cross-check** (scheduled): run `scripts/debian-check.sh` —
   downloads the Debian security tracker JSON dump and compares sid
   fixed_versions against our inventory. Second independent lens:
   catches fixes Arch already ships without waiting for an LFS advisory.
   PROVEN 2026-07-15 first run: found the systemd-260 local-privesc set
   (CVE-2026-40224/40225/40226) both other tiers missed, +6 more pkgs
   (issue #7). '(rc-fix)' = fixed in a Debian prerelease upload; verify
   a stable upstream release exists. Kernel excluded (tier 1b covers it).
   ~93 inventory names unmapped to Debian source names — curate the
   alias map in the script when reviewing.
1d. **Coverage tripwire** (LOCAL sessions only — reads the live
   filesystem, so the cloud routine cannot run it): run
   `scripts/coverage-check.sh` — diffs /usr/local/bin, /opt and the uv
   tool envs against the monitored sets (source inventory, tier-1b
   report names, ops/pypi-tools.txt, ops/coverage-ignore.txt). Any
   UNMONITORED line = something reached the system without joining a
   feed: add a report/inventory mapping, or an ignore entry WITH a
   reason. STALE-PYPI = uv envs drifted from the committed pin list —
   `--pypi`, commit. Run it in every local sweep and after any install
   batch. First run 2026-07-17 caught: chrome (!), discord, mise,
   cloudflared, gcloud, fzf/ripgrep/micro/fd + 26 PyPI packages —
   all invisible to every scheduled tier until then.
2. **LFS/BLFS advisories** (scheduled; remediation recipes): the old static
   pages (…/lfs/advisories/13.0.html) are FROZEN — use the live app:
   `curl -sL -X POST https://www.linuxfromscratch.org/advisories/index.php
    --data 'stype=Book&release=13.0&desc=true&submit=Search'`
   Covers the structural blind spot of tier 1: when Arch fixes a CVE by
   BACKPORT or already ships the new version, their tracker says "Fixed"
   and drops off our radar while our vanilla source build stays
   vulnerable. PROVEN 2026-07-15: first full cross-reference found 19
   actionable advisories tier 1 had hidden (issue #7) incl. Critical
   util-linux/vim and High openssl/openssh. Baseline: triaged through
   sa-13.0-140; only newer advisories need review on each run. Also carries
   build instructions (e.g. glibc consolidated patch) — check here for
   HOW to fix what tier 1 found, especially toolchain-class packages.
3. **Releases** (periodic, non-security): release-monitoring.org for the
   watchlist (kernel, glibc, openssl, curl, openssh, xorg-server, git,
   systemd, expat, libxml2, freetype, harfbuzz, dbus, sudo, libpng,
   libjpeg-turbo, pipewire) + GitHub latest for binaries (fzf, rg,
   micro, brave, vscode). Browsers behind = always priority 1.

UPDATE POLICY (decided 2026-07-19) — severity and exposure decide,
not semver distance. LAG alone (we're behind latest) is NOT actionable,
with one class of exceptions:
- Security-actionable (a released version/patch fixes a CVE affecting
  OUR version): upgrade via /lfs-upgrade, taking the SMALLEST release
  that contains the fix (usually the patch release, not the newest
  minor). Prioritize by severity + exposure (network-facing > local).
- Browsers and other untracked binary blobs (tier 1b): LAG itself is
  the signal — no CVE tracker covers them, so currency is the control.
  brave/chrome = priority 1; other Chromium shells past ~a month;
  CLI tools only if the gap contains a security fix.
- Everything else lagging with no security content: not worth a
  source rebuild + orphan sweep + VM boot cycle per version. Batch
  these in the periodic tier-3 release pass, or fold them into the
  next book-edition rebase. Don't chase minor versions for features.
- Kernel and toolchain-class (glibc, gcc, binutils): owner go/no-go
  always, regardless of what the gap contains.

Digest to the owner: actionable security items (CVE + our version + fixed
version + recommendation), kernel/glibc/systemd explicitly as go/no-go,
"watching" list only when it changes. Log the sweep in the on-system
STATE.md. Toolchain-class upgrades never proceed without the owner's go.
