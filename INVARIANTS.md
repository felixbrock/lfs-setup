# Invariants — "the repo IS the system" as a checked property

This register exists because of a lesson from seL4 (Klein et al.,
"seL4: Formal Verification of an OS Kernel", SOSP 2009): 80% of their
proof effort went into invariants — statements about system state that
must hold before and after every operation — and they found the
invariant list valuable in itself, independent of the proof. The
transferable shape for an ops repo is not theorem proving; it is
(1) state the invariants explicitly, (2) check all of them
deterministically, (3) make the check the post-condition of every
operational session. A boot that reaches SSH proves very little; these
checks are what "nothing escaped the machinery" actually means here.

The checker is `scripts/invariant-check.sh` (read-only; run it at
session end per the operator contract). A FAIL is a finding to fix or
register — never to ignore, never to silently baseline away.

## The register

- **I1 — every binary is accounted for.** Every file/symlink under
  /usr/{bin,sbin,lib,lib64,libexec} appears in a package manifest
  (/var/lib/lfs-pkg/*.list) or in the pinned I1 baseline (see
  limitations). A new unaccounted file means an install bypassed the
  stamp+manifest machinery — the analog of an object no capability
  points to.
- **I2 — every manifest traces to a build script.** Every
  /var/lib/lfs-pkg/*.list basename matches a build script in this
  repo's build/ or the private ops repo's build/. A manifest with no
  script is a change that never landed in a repo (violates the
  every-fix-is-a-script rule).
- **I3 — every staged source is pinned.** Every artifact under
  /sources appears in the provenance ledger ($LFS_LEDGER); `--hash`
  re-verifies the bytes. This closes the loop behind verify-source.sh:
  the gate checks artifacts on the way in, I3 checks nothing is
  sitting in /sources that never went through the gate.
- **I4 — everything runnable is monitored.** Delegates to
  scripts/coverage-check.sh (the coverage tripwire): every /usr/local/bin
  and /opt entry is in a monitored feed or ignored-with-reason.
- **I5 — build scripts are hygienic.** Every build script (except the
  legacy phase runners) has `set -euo pipefail`; package scripts
  ([0-9]*.sh) are one-command-per-line with no `&&` chains (two
  failure-visible idioms excepted: `$(cd … && pwd)`,
  `$([ … ] && echo …)`). Rationale: a left-side failure in a chain is
  invisible to set -e; seL4's bug data says exactly this class of
  simple, testing-resistant fault dominates.

## Known limitations (open hardening items)

- **The I1 baseline.** Manifest coverage has pre-existing gaps: vendor
  trees under /opt and root-run installs (kernel modules, firmware)
  never passed through `manifest()`, and a package **rebuild
  re-manifests only the files the rebuild actually touched** — the
  overwrite drops unchanged files from coverage. Rather than hiding
  this behind ignore patterns, `--baseline` pins the unaccounted set
  as found (same honest trade as the provenance ledger: it proves
  nothing about how those files got there; it makes every NEW
  unaccounted file detectable). Burn-down: backfill manifests via an
  owner-run root script per gap class, and fix `manifest()` in the
  run-alls to merge instead of overwrite on rebuild. The baseline is
  instance data and lives in the private ops repo.
- **Phase runners** (run-all.sh, download.sh) predate the pipefail
  rule and are excluded from I5; they are battle-tested and the chroot
  pipeline is historical.
- **Config drift is out of scope.** $HOME is covered separately by
  scripts/home-drift.sh; /etc drift detection is future work.

## Where the other seL4 lessons already live

For the record, the rest of the paper's method maps onto machinery
this repo already had (the invariant register just names it):
explicit side effects = `manifest()` by ctime; restart-don't-resume
interrupted operations = the stamp + full-rerun model; refinement of
book choices = the divergence register in AGENT-DESIGN.md; explicit
trust assumptions = PROVENANCE.md ("Assumptions"); prototype-first =
the VM rehearsal flow. Cost-of-change lesson: convention changes
(ledger format, stamp semantics, script skeleton) invalidate
assumptions across every script at once — batch them, make them rare,
and re-run this checker after.
